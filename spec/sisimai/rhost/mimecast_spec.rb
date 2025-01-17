require 'spec_helper'
require 'sisimai/mail'
require 'sisimai/data'
require 'sisimai/message'
require 'sisimai/rhost/mimecast'

describe Sisimai::Rhost::Mimecast do
  rs = {
    '01' => { 'status' => %r/\A5[.]0[.]0\z/, 'reason' => %r/policyviolation/ },
    '02' => { 'status' => %r/\A5[.]0[.]0\z/, 'reason' => %r/virusdetected/ },
  }
  describe 'bounce mail from Mimecast' do
    rs.each_key.each do |n|
      emailfn = sprintf('./set-of-emails/maildir/bsd/rhost-mimecast-%02d.eml', n)
      next unless File.exist?(emailfn)

      mailbox = Sisimai::Mail.new(emailfn)
      mtahost = %r/[.]mimecast[.]com\z/
      next unless mailbox

      while r = mailbox.data.read do
        mesg = Sisimai::Message.new(data: r)
        it('is Sisimai::Message object') { expect(mesg).to be_a Sisimai::Message }
        it('has array in "ds" accessor' ) { expect(mesg.ds).to be_a Array }
        it('has hash in "header" accessor' ) { expect(mesg.header).to be_a Hash }
        it('has hash in "rfc822" accessor' ) { expect(mesg.rfc822).to be_a Hash }
        it('has From line in "from" accessor' ) { expect(mesg.from.size).to be > 0 }

        mesg.ds.each do |e|
          example('spec is "SMTP"') { expect(e['spec']).to be == 'SMTP' }
          example 'recipient is email address' do
            expect(e['recipient']).to match(/\A.+[@].+[.].+\z/)
          end
          example('status is DSN') { expect(e['status']).to match(/\A\d[.]\d[.]\d\z/) }
          example('command is SMTP command') { expect(e['command']).to match(/\A[A-Z]{4}\z/) }
          example('date is not empty') { expect(e['date']).not_to be_empty }
          example('diagnosis is not empty') { expect(e['diagnosis']).not_to be_empty }
          example('action is not empty') { expect(e['action']).not_to be_empty }
          example('rhost is mx*.qq.com') { expect(e['rhost']).to match(mtahost) }
          example('alias exists') { expect(e['alias']).not_to be_nil }
          example('agent is ' + e['agent']) { expect(e['agent']).to match(/Postfix/) }
        end

        data = Sisimai::Data.make(data: mesg)
        data.each do |e|
          example('reason is String') { expect(e.reason.size).to be > 0 }
          example('reason matches') { expect(e.reason).to match(rs[n]['reason']) }
        end
      end
    end

  end
end


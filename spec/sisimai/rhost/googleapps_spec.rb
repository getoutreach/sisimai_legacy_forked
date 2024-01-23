require 'spec_helper'
require 'sisimai/mail'
require 'sisimai/data'
require 'sisimai/message'
require 'sisimai/rhost/googleapps'

describe SisimaiLegacy::Rhost::GoogleApps do
  rs = {
    '01' => { 'status' => %r/\A5[.]2[.]1\z/, 'reason' => %r/suspend/ },
  }
  describe 'bounce mail from GoogleApps' do
    rs.each_key.each do |n|
      emailfn = sprintf('./set-of-emails/maildir/bsd/rhost-google-apps-%02d.eml', n)
      next unless File.exist?(emailfn)

      mailbox = SisimaiLegacy::Mail.new(emailfn)
      mtahost = 'aspmx.l.google.com'
      next unless mailbox

      while r = mailbox.read do
        mesg = SisimaiLegacy::Message.new(data: r)
        it('is SisimaiLegacy::Message object') { expect(mesg).to be_a SisimaiLegacy::Message }
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
          example('rhost is ' + mtahost) { expect(e['rhost']).to be == mtahost }
          example('alias is ""') { expect(e['alias']).to be_empty }
          example('agent is Email::Sendmail') { expect(e['agent']).to be == 'Email::Sendmail' }
        end

        data = SisimaiLegacy::Data.make(data: mesg)
        data.each do |e|
          example('reason is String') { expect(e.reason.size).to be > 0 }
          example('reason matches') { expect(e.reason).to match(rs[n]['reason']) }
        end
      end
    end

  end
end


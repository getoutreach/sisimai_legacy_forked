require 'spec_helper'
require 'sisimai_legacy/mda'
require 'sisimai_legacy/mail'

describe SisimaiLegacy::MDA do
  cn = SisimaiLegacy::MDA

  smtperrors = [
    'Your message to neko was automatically rejected:'+"\n"+'Not enough disk space',
    'mail.local: Disc quota exceeded',
    'procmail: Quota exceeded while writing',
    'maildrop: maildir over quota.',
    'vdelivermail: user is over quota',
    'vdeliver: Delivery failed due to system quota violation',
  ]
  emailfn = './set-of-emails/maildir/bsd/rfc3464-01.eml'
  mailbox = SisimaiLegacy::Mail.new(emailfn)
  message = nil
  headers = { 'from' => 'Mail Delivery Subsystem' }

  describe '.scan' do
    context 'valid mailbox data' do
      while r = mailbox.read do
        smtperrors.each do |e|
          v = cn.scan(headers,e)
          it('returns Hash') { expect(v).to be_a Hash }
          it('has "mda" key') { expect(v['mda']).to be_a String }
          it('has "reason" key') { expect(v['reason']).to be_a String }
          it('has "message" key') { expect(v['message']).to be_a String }

          example('"mda" is MDA name') { expect(v['mda'].size).to be > 0 }
          example('"reason" is bounce reason') { expect(v['reason'].size).to be > 0 }
          example('"message" is error message') { expect(v['message'].size).to be > 0 }
        end
      end
    end
    context 'wrong number of arguments' do
      it 'raises ArgumentError' do
        expect { cn.scan }.to raise_error(ArgumentError)
      end
      it 'raises ArgumentError' do
        expect { cn.scan(nil) }.to raise_error(ArgumentError)
      end
      it 'raises ArgumentError' do
        expect { cn.scan(nil,nil,nil) }.to raise_error(ArgumentError)
      end
    end
  end


end

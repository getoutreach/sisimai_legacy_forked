require 'spec_helper'
require 'sisimai/data'
require 'sisimai/mail'
require 'sisimai/message'

describe SisimaiLegacy::Data do
  context 'without orders of email address headers' do
    mail = SisimaiLegacy::Mail.new('./set-of-emails/maildir/bsd/email-sendmail-03.eml')
    call = lambda do |argv|
      data = { 'x-mailer' => '', 'return-path' => '', 'type' => argv['datasrc'] }
      if cv = argv['message'].match(/^X-Mailer:\s*(.+)$/)
          data['x-mailer'] = cv[1]
      end

      if cv = argv['message'].match(/^Return-Path:\s*(.+)$/)
          data['return-path'] = cv[1]
      end
      data['from'] = argv['headers']['from'] || ''
      return data
    end

    while r = mail.read do
      mesg = SisimaiLegacy::Message.new(data: r, hook: call)
      data = SisimaiLegacy::Data.make(data: mesg)
      example 'SisimaiLegacy::Data.make returns Array' do
        expect(data).to be_a Array
      end

      data.each do |e|
        subject { e }
        it('is SisimaiLegacy::Data object') { is_expected.to be_a SisimaiLegacy::Data }
        example('#token returns String') { expect(e.token).to be_a String }
        example('#lhost returns String') { expect(e.lhost).to be_a String }
        example('#rhost returns String') { expect(e.rhost).to be_a String }
        example('#alias returns String') { expect(e.alias).to be_a String }
        example '#alias match with email address' do
          expect(e.alias).to match(/.+[@].+[.].+\z/)
        end
        example('#listid returns String') { expect(e.listid).to be_a String }
        example('#listid is empty') { expect(e.listid).to be_empty }

        example('#reason returns String') { expect(e.reason).to be_a String }
        example '#reason is "userunknown"' do
          expect(e.reason).to be == 'userunknown'
        end
        example('#subject returns String') { expect(e.subject).to be_a String }

        example '#timestamp is SisimaiLegacy::Time object' do
          expect(e.timestamp).to be_a SisimaiLegacy::Time
        end
        example('#timestamp#year is 2014') { expect(e.timestamp.year).to be == 2014 }
        example('#timestamp#month is 6') { expect(e.timestamp.month).to be == 6 }
        example('#timestamp#mday is 21 or 22') { expect(e.timestamp.mday.to_s).to match(/\A2[12]\z/) }
        example('#timestamp#wday is 6 or 7') { expect(e.timestamp.cwday.to_s).to match(/\A[67]\z/) }

        example '#addresser is SisimaiLegacy::Address object' do
          expect(e.addresser).to be_a SisimaiLegacy::Address
        end
        example('#addresser#host returns String') { expect(e.addresser.host).to be_a String }
        example('#addresser#host is a domain part') { expect(e.addresser.host).to match(/\A.+[.].+\z/) }
        example('#addresser#user returns String') { expect(e.addresser.user).to be_a String }
        example('#addresser#user is a local part') { expect(e.addresser.user).to match(/\A[a-z]+\z/) }
        example('#addresser#address returns String') { expect(e.addresser.address).to be_a String }
        example '#addresser#address is an email address' do
          expect(e.addresser.address).to match(/\A[a-z]+[@].+[.].+\z/)
        end
        example '#addresser#host is #senderdomain' do
          expect(e.addresser.host).to be == e.senderdomain
        end

        example '#recipient is SisimaiLegacy::Address object' do
          expect(e.recipient).to be_a SisimaiLegacy::Address
        end
        example('#recipient#host returns String') { expect(e.recipient.host).to be_a String }
        example('#recipient#host is a domain part') { expect(e.recipient.host).to match(/\A.+[.].+\z/) }
        example('#recipient#user returns String') { expect(e.recipient.user).to be_a String }
        example('#recipient#user is a local part') { expect(e.recipient.user).to match(/\A[0-9a-z]+\z/) }
        example('#recipient#address returns String') { expect(e.recipient.address).to be_a String }
        example '#recipient#address is an email address' do
          expect(e.recipient.address).to match(/\A[0-9a-z]+[@].+[.].+\z/)
        end
        example '#recipient#host is #destination' do
          expect(e.recipient.host).to be == e.destination
        end

        example('#messageid is String') { expect(e.messageid).to be_a String }
        example '#messageid includes "@"' do
          expect(e.messageid).to match(/\A.+[@].+[.].+\z/)
        end

        example('#smtpagent is String') { expect(e.smtpagent).to be_a String }
        example('#smtpagent is "Email::Sendmail"') { expect(e.smtpagent).to be == 'Email::Sendmail' }

        example('#smtpcommand is String') { expect(e.smtpcommand).to be_a String }
        example('#smtpcommand is "DATA"') { expect(e.smtpcommand).to be == 'DATA' }

        example('#diagnosticcode is String') { expect(e.diagnosticcode).to be_a String }
        example('#diagnosticcode.size > 0') { expect(e.diagnosticcode.size).to be > 0 }

        example('#diagnostictype is String') { expect(e.diagnostictype).to be_a String }
        example('#diagnostictype is "SMTP"') { expect(e.diagnostictype).to be == 'SMTP' }

        example('#deliverystatus is String') { expect(e.deliverystatus).to be_a String }
        example '#deliverystatus is DSN value(X.Y.Z)' do
          expect(e.deliverystatus).to match(/\A[45][.]\d[.]\d+\z/)
        end

        example('#timezoneoffset is String') { expect(e.timezoneoffset).to be_a String }
        example('#timezomeoffset is +0900') { expect(e.timezoneoffset).to be == '+0900' }

        example('#replycode is String') { expect(e.replycode).to be_a String }
        example('#replycode is 550') { expect(e.replycode).to be == '550' }

        example('#action is String') { expect(e.action).to be_a String }
        example('#action is "failed"') { expect(e.action).to be == 'failed' }

        example('#feedbacktype is String') { expect(e.feedbacktype).to be_a String }
        example('#feedbacktype is empty') { expect(e.feedbacktype).to be_empty }

        example('#catch is Hash') { expect(e.catch).to be_a Hash }
        example('#catch[type] is "email"') { expect(e.catch['type']).to be == 'email' }
        example('#catch[x-mailer] is String') { expect(e.catch['x-mailer']).to be_a String }
        example('#catch[x-mailer] includes "Apple"') { expect(e.catch['x-mailer']).to match(/Apple/) }
        example('#catch[return-path] is String') { expect(e.catch['return-path']).to be_a String }
        example('#catch[return-path] includes "kijitora"') { expect(e.catch['return-path']).to match(/kijitora/) }
        example('#catch[from] is String') { expect(e.catch['from']).to be_a String }
        example('#catch[from] includes "@"') { expect(e.catch['from']).to match(/[@]/) }
      end
    end
  end

  context 'with orders of email address headers' do
    file = './set-of-emails/maildir/bsd/email-sendmail-04.eml'
    mail = SisimaiLegacy::Mail.new(file)

    while r = mail.read do
      mesg = SisimaiLegacy::Message.new(data: r)
      list = {
        'recipient' => ['X-Failed-Recipient', 'To'],
        'addresser' => ['Return-Path', 'From', 'X-Envelope-From'],
      }
      data = SisimaiLegacy::Data.make(data: mesg, order: list)
      example 'SisimaiLegacy::Data.make returns Array' do
        expect(data).to be_a Array
      end

      data.each do |e|
        subject { e }
        it('is SisimaiLegacy::Data object') { is_expected.to be_a SisimaiLegacy::Data }
        example('#token returns String') { expect(e.token).to be_a String }
        example('#lhost returns String') { expect(e.lhost).to be_a String }
        example '#lhost does not include " "' do
          expect(e.lhost).not_to match(/[ ]/)
        end

        example('#rhost returns String') { expect(e.rhost).to be_a String }
        example '#rhost does not include " "' do
          expect(e.rhost).not_to match(/[ ]/)
        end

        example('#listid returns String') { expect(e.listid).to be_a String }
        example '#listid does not include " "' do
          expect(e.listid).not_to match(/[ ]/)
        end

        example('#reason returns String') { expect(e.reason).to be_a String }
        example '#reason is "rejected"' do
          expect(e.reason).to be == 'rejected'
        end
        example('#subject returns String') { expect(e.subject).to be_a String }

        example '#timestamp is SisimaiLegacy::Time object' do
          expect(e.timestamp).to be_a SisimaiLegacy::Time
        end
        example('#timestamp#year is 2009') { expect(e.timestamp.year).to be == 2009 }
        example('#timestamp#month is 4') { expect(e.timestamp.month).to be == 4 }
        example('#timestamp#mday is 29 or 30') { expect(e.timestamp.mday.to_s).to match(/\A(?:29|30)\z/) }
        example('#timestamp#wday is 3 or 4') { expect(e.timestamp.cwday.to_s).to match(/\A[34]\z/) }

        example '#addresser is SisimaiLegacy::Address object' do
          expect(e.addresser).to be_a SisimaiLegacy::Address
        end
        example('#addresser#host returns String') { expect(e.addresser.host).to be_a String }
        example('#addresser#host is a domain part') { expect(e.addresser.host).to match(/\A.+[.].+\z/) }
        example('#addresser#user returns String') { expect(e.addresser.user).to be_a String }
        example('#addresser#user is a local part') { expect(e.addresser.user).to match(/\A[a-z]+\z/) }
        example('#addresser#address returns String') { expect(e.addresser.address).to be_a String }
        example '#addresser#address is an email address' do
          expect(e.addresser.address).to match(/\A[a-z]+[@].+[.].+\z/)
        end
        example '#addresser#host is #senderdomain' do
          expect(e.addresser.host).to be == e.senderdomain
        end

        example '#recipient is SisimaiLegacy::Address object' do
          expect(e.recipient).to be_a SisimaiLegacy::Address
        end
        example('#recipient#host returns String') { expect(e.recipient.host).to be_a String }
        example('#recipient#host is a domain part') { expect(e.recipient.host).to match(/\A.+[.].+\z/) }
        example('#recipient#user returns String') { expect(e.recipient.user).to be_a String }
        example('#recipient#user is a local part') { expect(e.recipient.user).to match(/\A[a-z]+\z/) }
        example('#recipient#address returns String') { expect(e.recipient.address).to be_a String }
        example '#recipient#address is an email address' do
          expect(e.recipient.address).to match(/\A[a-z]+[@].+[.].+\z/)
        end
        example '#recipient#host is #destination' do
          expect(e.recipient.host).to be == e.destination
        end

        example('#messageid is String') { expect(e.messageid).to be_a String }
        example '#messageid does not include " "' do
          expect(e.messageid).not_to match(/[ ]/)
        end

        example('#smtpagent is String') { expect(e.smtpagent).to be_a String }
        example('#smtpagent is "Email::Sendmail"') { expect(e.smtpagent).to be == 'Email::Sendmail' }

        example('#smtpcommand is String') { expect(e.smtpcommand).to be_a String }
        example('#smtpcommand is "MAIL"') { expect(e.smtpcommand).to be == 'MAIL' }

        example('#diagnosticcode is String') { expect(e.diagnosticcode).to be_a String }
        example('#diagnosticcode.size > 0') { expect(e.diagnosticcode.size).to be > 0 }

        example('#diagnostictype is String') { expect(e.diagnostictype).to be_a String }
        example('#diagnostictype is "SMTP"') { expect(e.diagnostictype).to be == 'SMTP' }

        example('#deliverystatus is String') { expect(e.deliverystatus).to be_a String }
        example '#deliverystatus is DSN value(X.Y.Z)' do
          expect(e.deliverystatus).to match(/\A[45][.]\d[.]\d+\z/)
        end

        example('#timezoneoffset is String') { expect(e.timezoneoffset).to be_a String }
        example('#timezomeoffset is +0900') { expect(e.timezoneoffset).to be == '+0900' }

        example('#replycode is String') { expect(e.replycode).to be_a String }
        example('#replycode is 553') { expect(e.replycode).to be == '553' }

        example('#action is String') { expect(e.action).to be_a String }
        example('#action is "failed"') { expect(e.action).to be == 'failed' }

        example('#feedbacktype is String') { expect(e.feedbacktype).to be_a String }
        example('#feedbacktype is empty') { expect(e.feedbacktype).to be_empty }
      end
    end
  end

  context 'not bounce mail' do
    file = [
      './set-of-emails/maildir/not/is-not-bounce-01.eml',
      './set-of-emails/maildir/not/is-not-bounce-02.eml',
    ]
    file.each do |e|
      mail = SisimaiLegacy::Mail.new(e)
      while r = mail.read do
        mesg = SisimaiLegacy::Message.new( data: r )
        data = SisimaiLegacy::Data.make( data: mesg )
        it('returns SisimaiLegacy::Message') { expect(mesg).to be_a SisimaiLegacy::Message }
        it('returns nil') { expect(data).to be nil }
      end
    end
  end
end

require 'spec_helper'
require 'sisimai_legacy'
require 'json'

describe Sisimai do
  sampleemail = {
    :mailbox => './set-of-emails/mailbox/mbox-0',
    :maildir => './set-of-emails/maildir/bsd',
    :memory  => './set-of-emails/mailbox/mbox-1',
    :jsonobj => './set-of-emails/jsonobj/json-amazonses-01.json',
  }
  isnotbounce = {
    :maildir => './set-of-emails/maildir/not',
  }

  describe 'SisimaiLegacy::VERSION' do
    subject { SisimaiLegacy::VERSION }
    it('returns version') { is_expected.not_to be nil }
    it('returns String' ) { is_expected.to be_a(String) }
    it('matches X.Y.Z'  ) { is_expected.to match(/\A\d[.]\d+[.]\d+/) }
  end

  describe '.version' do
    subject { SisimaiLegacy.version }
    it('is String') { is_expected.to be_a(String) }
    it('is ' + SisimaiLegacy::VERSION) { is_expected.to eq SisimaiLegacy::VERSION }
  end

  describe '.sysname' do
    subject { SisimaiLegacy.sysname }
    it('is String')     { is_expected.to be_a(String) }
    it('returns bounceHammer') { is_expected.to match(/bounceHammer/i) }
  end

  describe '.libname' do
    subject { SisimaiLegacy.libname }
    it('is String')       { is_expected.to be_a(String) }
    it('returns Sisimai') { expect(SisimaiLegacy.libname).to eq 'Sisimai' }
  end

  describe '.make' do
    context 'valid email file' do
      [:mailbox, :maildir, :jsonobj, :memory].each do |e|

        if e.to_s == 'jsonobj'
          jf = File.open(sampleemail[e], 'r')
          js = jf.read
          jf.close

          if RUBY_PLATFORM =~ /java/
            # java-based ruby environment like JRuby.
            require 'jrjackson'
            jsonobject = JrJackson::Json.load(js)
          else
            require 'oj'
            jsonobject = Oj.load(js)
          end
          mail = SisimaiLegacy.make(jsonobject, input: 'json')

        elsif e.to_s == 'memory'
          mf = File.open(sampleemail[e], 'r')
          ms = mf.read
          mf.close

          mail = SisimaiLegacy.make(ms)
        else
          mail = SisimaiLegacy.make(sampleemail[e], input: 'email')
        end
        subject { mail }
        it('is Array') { is_expected.to be_a Array }
        it('have data') { expect(mail.size).to be > 0 }

        mail.each do |ee|
          it 'contains SisimaiLegacy::Data' do
            expect(ee).to be_a SisimaiLegacy::Data
          end

          describe 'each accessor of SisimaiLegacy::Data' do
            example '#timestamp is SisimaiLegacy::Time' do
              expect(ee.timestamp).to be_a SisimaiLegacy::Time
            end
            example '#addresser is SisimaiLegacy::Address' do
              expect(ee.addresser).to be_a SisimaiLegacy::Address
            end
            example '#recipient is SisimaiLegacy::Address' do
              expect(ee.recipient).to be_a SisimaiLegacy::Address
            end

            example '#addresser#address returns String' do
              expect(ee.addresser.address).to be_a String
              expect(ee.addresser.address.size).to be > 0
            end
            example '#recipient#address returns String' do
              expect(ee.recipient.address).to be_a String
              expect(ee.recipient.address.size).to be > 0
            end

            example '#reason returns String' do
              expect(ee.reason).to be_a String
            end
            example '#replycode returns String' do
              expect(ee.replycode).to be_a String
            end
          end

          describe 'each instance method of SisimaiLegacy::Data' do
            describe '#damn' do
              damn = ee.damn
              example '#damn returns Hash' do
                expect(damn).to be_a Hash
                expect(damn.each_key.size).to be > 0
              end

              describe 'damned data' do
                example '["addresser"] is #addresser#address' do
                  expect(damn['addresser']).to be == ee.addresser.address
                end
                example '["recipient"] is #recipient#address' do
                  expect(damn['recipient']).to be == ee.recipient.address
                end

                damn.each_key do |eee|
                  next if ee.send(eee).class.to_s =~ /\ASisimaiLegacy::/
                  next if eee == 'subject'
                  if eee == 'catch'
                    example "['#{eee}'] is ''" do
                      expect(damn[eee]).to be_empty
                    end
                  else
                    example "['#{eee}'] is ##{eee}" do
                      expect(damn[eee]).to be == ee.send(eee)
                    end
                  end
                end
              end
            end

            describe '#dump' do
              dump = ee.dump('json')
              example '#dump returns String' do
                expect(dump).to be_a String
                expect(dump.size).to be > 0
              end
            end
          end

        end

        if e.to_s == 'jsonobj'
          callbackto = lambda do |argv|
            data = { 'feedbackid' => '', 'account-id'  => '', 'source-arn'  => '' }
            data['type'] = argv['datasrc']
            data['feedbackid'] = argv['bounces']['bounce']['feedbackId'] || ''
            data['account-id'] = argv['bounces']['mail']['sendingAccountId'] || ''
            data['source-arn'] = argv['bounces']['mail']['sourceArn'] || ''
            return data
          end

          jf = File.open(sampleemail[e], 'r')
          js = jf.read
          jf.close

          if RUBY_PLATFORM =~ /java/
            # java-based ruby environment like JRuby.
            require 'jrjackson'
            jsonobject = JrJackson::Json.load(js)
          else
            require 'oj'
            jsonobject = Oj.load(js)
          end
          havecaught = SisimaiLegacy.make(jsonobject, hook: callbackto, input: 'json')

        else
          callbackto = lambda do |argv|
            data = {
              'x-mailer' => '',
              'return-path' => '',
              'type' => argv['datasrc'],
              'x-virus-scanned' => '',
            }
            if cv = argv['message'].match(/^X-Mailer:\s*(.+)$/)
                data['x-mailer'] = cv[1]
            end

            if cv = argv['message'].match(/^Return-Path:\s*(.+)$/)
                data['return-path'] = cv[1]
            end
            data['from'] = argv['headers']['from'] || ''
            data['x-virus-scanned'] = argv['headers']['x-virus-scanned'] || ''
            return data
          end
          havecaught = SisimaiLegacy.make(sampleemail[e],
                                    hook: callbackto,
                                    input: 'email',
                                    field: ['X-Virus-Scanned'])
        end

        havecaught.each do |ee|
          it('is SisimaiLegacy::Data') { expect(ee).to be_a SisimaiLegacy::Data }
          it('is Hash') { expect(ee.catch).to be_a Hash }

          if e.to_s == 'jsonobj'
            it('"type" is "json"') { expect(ee.catch['type']).to be == 'json' }
            it('exists "feedbackid" key') { expect(ee.catch.key?('feedbackid')).to be true }
            it('exists "account-id" key') { expect(ee.catch.key?('account-id')).to be true }
            it('exists "source-arn" key') { expect(ee.catch.key?('source-arn')).to be true }

          else
            it('"type" is "email"') { expect(ee.catch['type']).to be == 'email' }
            it('exists "x-mailer" key') { expect(ee.catch.key?('x-mailer')).to be true }
            if ee.catch['x-mailer'].size > 0
              it 'matches with X-Mailer' do
                expect(ee.catch['x-mailer']).to match(/[A-Z]/)
              end
            end

            it('exists "return-path" key') { expect(ee.catch.key?('return-path')).to be true }
            if ee.catch['return-path'].size > 0
              it 'matches with Return-Path' do
                expect(ee.catch['return-path']).to match(/(?:<>|.+[@].+|<mailer-daemon>)/i)
              end
            end

            it('exists "from" key') { expect(ee.catch.key?('from')).to be true }
            if ee.catch['from'].size > 0
              it 'matches with From' do
                expect(ee.catch['from']).to match(/(?:<>|.+[@].+|<?mailer-daemon>?)/i)
              end
            end

            it('exists "x-virus-scanned" key') { expect(ee.catch.key?('x-virus-scanned')).to be true }
            if ee.catch['x-virus-scanned'].size > 0
              it 'matches with Clam or Amavis' do
                expect(ee.catch['x-virus-scanned']).to match(/(?:amavis|clam)/i)
              end
            end

          end
        end

        isntmethod = SisimaiLegacy.make(sampleemail[e], hook: {})
        if isntmethod.is_a? Array
          isntmethod.each do |ee|
            it('is SisimaiLegacy::Data') { expect(ee).to be_a SisimaiLegacy::Data }
            it('is Nil') { expect(ee.catch).to be_nil }
          end
        end

      end

    end

    context 'non-bounce email' do
      example 'returns nil' do
        expect(SisimaiLegacy.make(isnotbounce[:maildir])).to be nil
        expect(SisimaiLegacy.make(nil)).to be nil
      end
    end

    context 'wrong number of arguments' do
      it 'raises ArgumentError' do
        expect { SisimaiLegacy.make }.to raise_error(ArgumentError)
        expect { SisimaiLegacy.make(nil, nil) }.to raise_error(ArgumentError)
      end
    end

    context 'Invalid value in arguments' do
      it 'raises RuntimeError' do
        expect { SisimaiLegacy.make('/dev/null', field: 'neko') }.to raise_error(RuntimeError)
        expect { SisimaiLegacy.make('/dev/null', input: 'neko') }.to raise_error(RuntimeError)
      end
    end
  end

  describe '.dump' do
    tobetested = %w|
      addresser recipient senderdomain destination reason timestamp
      token smtpagent
    |

    context 'valid email file' do
      [:mailbox, :maildir].each do |e|

        jsonstring = SisimaiLegacy.dump(sampleemail[e])
        it('returns String') { expect(jsonstring).to be_a String }
        it('is not empty') { expect(jsonstring.size).to be > 0 }

        describe 'Generate Ruby object from JSON string' do
          rubyobject = JSON.parse(jsonstring)
          it('returns Array') { expect(rubyobject).to be_a Array }

          rubyobject.each do |ee|
            it 'is a flat data structure' do
              expect(ee).to be_a Hash
              expect(ee['addresser']).to be_a ::String
              expect(ee['recipient']).to be_a ::String
              expect(ee['timestamp']).to be_a Integer
            end

            tobetested.each do |eee|
              example("#{eee} = #{ee[eee]}") do
                if eee == 'senderdomain' && ee['addresser'] =~ /\A(?:postmaster|MAILER-DAEMON)\z/
                  expect(ee[eee]).to be_empty
                else
                  expect(ee[eee].size).to be > 0
                end
              end
            end
          end
        end
      end
    end

    context 'non-bounce email' do
      it 'returns "[]"' do
        expect(SisimaiLegacy.dump(isnotbounce[:maildir])).to be == '[]'
      end
      it 'returns nil' do
        expect(SisimaiLegacy.dump(nil)).to be_nil
      end
    end

    context 'wrong number of arguments' do
      it 'raises ArgumentError' do
        expect { SisimaiLegacy.dump}.to raise_error(ArgumentError)
        expect { SisimaiLegacy.dump(nil, nil) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.engine' do
    it 'returns Hash' do
      expect(SisimaiLegacy.engine).to be_a Hash
      expect(SisimaiLegacy.engine.keys.size).to be > 0
    end
    it 'including a module information' do
      SisimaiLegacy.engine.each do |e, f|
        expect(e).to match(/\ASisimaiLegacy::/)
        expect(f).to be_a String
        expect(f.size).to be > 0
      end
    end

    context 'wrong number of arguments' do
      it 'raises ArgumentError' do
        expect { SisimaiLegacy.engine(nil)}.to raise_error(ArgumentError)
        expect { SisimaiLegacy.engine(nil, nil) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.reason' do
    it 'returns Hash' do
      expect(SisimaiLegacy.reason).to be_a Hash
      expect(SisimaiLegacy.reason.keys.size).to be > 0
    end
    it 'including a reason description' do
      SisimaiLegacy.reason.each do |e, f|
        expect(e).to match(/\A[A-Z]/)
        expect(f).to be_a String
        expect(f.size).to be > 0
      end
    end

    context 'wrong number of arguments' do
      it 'raises ArgumentError' do
        expect { SisimaiLegacy.reason(nil)}.to raise_error(ArgumentError)
        expect { SisimaiLegacy.reason(nil, nil) }.to raise_error(ArgumentError)
      end
    end
  end

end

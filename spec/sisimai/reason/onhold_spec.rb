require 'spec_helper'
require 'sisimai'
require 'json'
require 'sisimai/reason/onhold'

thatsonhold = './set-of-emails/to-be-debugged-because/reason-is-onhold'
if File.exist?(thatsonhold)
  describe Sisimai do
    describe '.make' do
      mail = SisimaiLegacy.make(thatsonhold)
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

          example '#reason is "onhold"' do
            expect(ee.reason).to be_a String
            expect(ee.reason).to be == 'onhold'
          end
          example '#replycode returns String' do
            expect(ee.replycode).to be_a String
          end

          example 'SisimaiLegacy::Reason::OnHold.true returns true' do
            expect(SisimaiLegacy::Reason::OnHold.true(ee)).to be true
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
    end

    describe '.dump' do
      jsonstring = SisimaiLegacy.dump(thatsonhold)
      it('returns String') { expect(jsonstring).to be_a String }
      it('is not empty') { expect(jsonstring.size).to be > 0 }
    end

  end

end

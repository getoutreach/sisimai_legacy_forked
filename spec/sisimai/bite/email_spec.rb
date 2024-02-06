require 'spec_helper'
require 'sisimai_legacy/bite/email'

describe SisimaiLegacy::Bite::Email do
  describe '.INDICATORS' do
    it('returns Hash') { expect(SisimaiLegacy::Bite::Email.INDICATORS).to be_a Hash }
  end
  describe '.headerlist' do
    it('returns Array') { expect(SisimaiLegacy::Bite::Email.headerlist).to be_a Array }
    it('is empty list') { expect(SisimaiLegacy::Bite::Email.headerlist).to be_empty }
  end
  describe '.index' do
    it('returns Array') { expect(SisimaiLegacy::Bite::Email.index).to be_a Array }
    it('is not empty' ) { expect(SisimaiLegacy::Bite::Email.index.size).to be > 0 }
  end
  describe '.scan' do
    it('returns nil') { expect(SisimaiLegacy::Bite::Email.scan).to be nil }
  end
end



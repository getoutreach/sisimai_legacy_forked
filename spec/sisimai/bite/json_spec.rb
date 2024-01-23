require 'spec_helper'
require 'sisimai_legacy/bite/json'

describe SisimaiLegacy::Bite::JSON do
  describe '.headerlist' do
    it('returns Array') { expect(SisimaiLegacy::Bite::JSON.headerlist).to be_a Array }
    it('is empty list') { expect(SisimaiLegacy::Bite::JSON.headerlist).to be_empty }
  end
  describe '.index' do
    it('returns Array') { expect(SisimaiLegacy::Bite::JSON.index).to be_a Array }
    it('is not empty' ) { expect(SisimaiLegacy::Bite::JSON.index.size).to be > 0 }
  end
  describe '.scan' do
    it('returns nil') { expect(SisimaiLegacy::Bite::JSON.scan).to be nil }
  end
  describe '.adapt' do
    it('returns nil') { expect(SisimaiLegacy::Bite::JSON.adapt).to be nil }
  end
end


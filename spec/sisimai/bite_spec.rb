require 'spec_helper'
require 'sisimai/bite'

describe SisimaiLegacy::Bite do
  describe '.DELIVERYSTATUS' do
    it('returns Hash') { expect(SisimaiLegacy::Bite.DELIVERYSTATUS).to be_a Hash }
  end
  describe '.smtpagent' do
    it('returns String') { expect(SisimaiLegacy::Bite.smtpagent).to be_a Object::String }
  end
  describe '.description' do
    it('returns String') { expect(SisimaiLegacy::Bite.description).to be_a Object::String }
  end
end


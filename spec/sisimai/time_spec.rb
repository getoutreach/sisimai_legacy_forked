require 'spec_helper'
require 'sisimai_legacy/time'

describe SisimaiLegacy::Time do
  cn = SisimaiLegacy::Time
  to = cn.new
  describe '.new' do
    it('returns SisimaiLegacy::Time object') { expect(to).to be_a SisimaiLegacy::Time }
  end

  describe '.to_json' do
    it('returns Integer') { expect(to.to_json).to be_a Integer }
    it('returns machine time') { expect(to.to_json).to eq(to.to_time.to_i) }
  end
end

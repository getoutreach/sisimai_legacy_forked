require 'spec_helper'
require 'sisimai_legacy/order/email'

describe SisimaiLegacy::Order::Email do
  cn = SisimaiLegacy::Order::Email
  describe '.another' do
    another = cn.another
    subject { another }
    it('returns Array') { is_expected.to be_a Array }
    it('have values')   { expect(another.size).to be > 0 }
    another.each do |e|
      it('is a module') { expect(e.class).to be_a Class }
      it('has a module name') { expect(e.to_s).to match(/\ASisimaiLegacy::Bite::(?:Email|JSON)::/) }
    end
  end
  describe '.headers' do
    headers = cn.headers
    subject { headers }
    it('returns Hash') { is_expected.to be_a Hash }
    headers.each_key do |e|
      it('has a Hash') { expect(headers[e]).to be_a Hash }
      it 'have some header names' do
        expect(headers[e].keys.size).to be > 0
      end
      headers[e].each_key do |f|
        it('has a value(1)') { expect(headers[e][f]).to be == 1 }
      end
    end
  end

  describe '.by("subject")' do
    orderby = cn.by('subject')
    subject { orderby }
    it('returns Hash') { is_expected.to be_a Hash }
    orderby.each_key do |e|
      it('is a String') { expect(e).to be_a String }
      it('is an Array') { expect(orderby[e]).to be_a Array }
      orderby[e].each do |f|
        it('is String') { expect(f).to be_a String }
        it('is a module name') { expect(f).to match(/\ASisimaiLegacy::Bite::(?:Email|JSON)::/) }
      end
    end
  end
end


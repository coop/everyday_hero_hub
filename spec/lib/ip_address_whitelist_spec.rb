require 'spec_helper'
require 'ip_address_whitelist'

describe IPAddressWhitelist do
  describe '#include?' do
    let(:whitelist) { IPAddressWhitelist.new('192.30.252.0/22') }

    it 'is true when address is included' do
      expect(whitelist.include?('192.30.252.51')).to be_true
    end

    it 'is false when address is not included' do
      expect(whitelist.include?('127.0.0.0')).to be_false
    end
  end
end

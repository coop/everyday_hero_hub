class IPAddressWhitelist
  def initialize *ip_addresses
    self.ip_addresses = ip_addresses
  end

  # Determine if the given IP address is included in our whitelist.
  #
  # @return [Boolean]
  def include? remote_ip_address
    ip_addresses.any? do |ip_address|
      ip_address.include? remote_ip_address
    end
  end

  private

  attr_reader :ip_addresses

  def ip_addresses= ip_addresses
    @ip_addresses = ip_addresses.map do |ip_addr|
      IPAddr.new ip_addr
    end
  end
end

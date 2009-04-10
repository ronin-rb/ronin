require 'ronin/extensions/ip_addr'

describe IPAddr do
  before(:all) do
    @fixed_addr = IPAddr.new('10.1.1.2')
    @class_c = IPAddr.new('10.1.1.2/24')
  end

  it "should only iterate over one IP address for an address" do
    addresses = @fixed_addr.map { |ip| IPAddr.new(ip) }

    addresses.length.should == 1
    @fixed_addr.include?(addresses.first)
  end

  it "should iterate over all IP addresses contained within the IP range" do
    @class_c.each do |ip|
      @class_c.include?(IPAddr.new(ip)).should == true
    end
  end
end

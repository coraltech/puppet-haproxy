
module Puppet::Parser::Functions
  newfunction(:proxy_ports, :type => :rvalue) do |args|
    
    unless args[0].is_a?(Hash)
      Puppet.warning "proxy_ports takes one argument, the input hash"
      nil
      
    else
      ports = Array.new
      
      args[0].each do |proxy_name, proxy|
        ports << proxy['port']
      end
      
      ports
    end
  end
end
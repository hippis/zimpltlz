require 'net/ssh'

VLAN_START = "VLAN Interface with name"
VLAN_END = "#"

VLAN_TAG_ROW = "Admin State:"
UNTAG_START = "Untag:"
TAG_START = "Tag:"

IP_ROW = "Primary IP:"

Net::SSH.start( "192.168.10.2", "reader", :password => "" ) do |ssh|

  result = ssh.exec!('show switch | include SysName')
  result.each_line do |line|
    if line.start_with?("SysName")
      name_array = line.split(" ")
      puts ""
      puts "Switch: " + name_array[1].to_s
      puts ""
    end
  end

  result = ssh.exec!('show vlan detail')

  port_parsing = false

  result.each_line do |line|

    line = line.strip
    line = line.gsub(/\s+/,' ')

    if line.start_with?(VLAN_START)

      name_array = line.split(" ")
      vlan_name = name_array[4]

      puts "----------"
      print vlan_name

    elsif line.start_with?(VLAN_TAG_ROW)

      name_array = line.split(" ")
      puts " ( " + name_array[6] + " ) "

    elsif line.start_with?(TAG_START) || line.start_with?(UNTAG_START) || port_parsing
      
      if line.end_with?","
        port_parsing = true
        print line + " "
      else
        port_parsing = false
        puts line
      end

    elsif line.start_with?(IP_ROW)

      name_array = line.split(" ")
      puts "IP: " + name_array[2]

    end

  end

end

puts "----------"


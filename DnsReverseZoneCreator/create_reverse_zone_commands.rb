
DOMAIN_POSTFIX = ".my.home."
DESIRED_RECORD = " A "
VALID_ADDRESSES = ["200","187"]

system '/usr/bin/dig axfr my.home 192.168.10.201 > DATA.txt'

if File.exist?('DATA.txt')

  File.open('DATA.txt').each do |line|

    line = line.gsub(/\s+/,' ')

    if line.include? DOMAIN_POSTFIX

      if line.include? DESIRED_RECORD

        record_array = line.split(" ")

        my_name = record_array[0]
        my_ip = record_array[4]

        if VALID_ADDRESSES.any? { |item| my_ip.include?(item) }

          ip_array = my_ip.split(".")

          puts "prereq yxdomain " + my_name
          puts "update delete " + ip_array[3] + "." + ip_array[2] + "." + ip_array[1] + "." + ip_array[0] + ".in-addr.arpa."
          puts "send"
          puts "prereq nxdomain " + my_name 
          puts "update add " + ip_array[3] + "." + ip_array[2] + "." + ip_array[1] + "." + ip_array[0] + ".in-addr.arpa. 120 IN PTR " + my_name
          puts "send"

        end

      end

    end

  end

end


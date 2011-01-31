#!/usr/bin/env ruby

require 'rubygems'
require 'active_shipping'
include ActiveMerchant::Shipping

#  :login:    # meter number
#  :password: # password from email
#  :key:      # key from initial web page
#  :account:  # account number

fedex = FedEx.new(YAML::load(ERB.new(IO.read(
	'config/fed_ex.yml'
)).result)['test']);

tracking_numbers = %w( 
	134619889171013 
	134619889171020 
	918192619433536 
	918192619433550 
	918192619433567 
	918192619433710 
	918192619433734 
	450043071490 
	450043071505 
	065140275594099
)

tracking_numbers.each do |tracking_number|
	puts "---- #{tracking_number}"
	begin
		tracking_info = fedex.find_tracking_info(
			tracking_number, :test => true )

		tracking_info.shipment_events.each do |event|
			puts "#{event.name} at #{event.location.city}, " <<
				"#{event.location.state} on #{event.time}. #{event.message}"
		end

	rescue Exception => e
		puts "tracking number : #{tracking_number} : raised an error."
		puts e.inspect
	end
end

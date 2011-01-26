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
	
	tracking_numbers = %w( 065140275594099 )
	
	tracking_numbers.each do |tracking_number|
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

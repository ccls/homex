class ShippingWorker < BackgrounDRb::MetaWorker
	set_worker_name :shipping_worker
	def create(args = nil)
		# this method is called, when worker is loaded for the first time

		update_shipping_statuses
		# time argument is in seconds
		add_periodic_timer(1800) { update_shipping_statuses }
	end
	
	def update_shipping_statuses
		puts "Updating Shipping Statuses:" << Time.now.to_s
		Package.undelivered.each do |package|
			puts "BEFORE: Package ##{package.tracking_number} status #{package.status}"
			package.update_status
			puts "-AFTER: Package ##{package.tracking_number} status #{package.status}"
		end
		puts "Done Updating Shipping Statuses:" << Time.now.to_s
#		$last_shipping_update = Time.now
		Package.just_updated
	end

end


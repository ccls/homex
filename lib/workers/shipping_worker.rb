class ShippingWorker < BackgrounDRb::MetaWorker
	set_worker_name :shipping_worker
	def create(args = nil)
		# this method is called, when worker is loaded for the first time

    # time argument is in seconds
    add_periodic_timer(3600) { update_shipping_statuses }
	end
	
	def update_shipping_statuses
		puts "Updating Shipping Statuses"
		Package.all.each do |package|
			puts "Package ##{package.tracking_number} status #{package.status}"
		end
	end

end


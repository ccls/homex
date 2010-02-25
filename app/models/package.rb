require 'active_shipping'
class Package < ActiveRecord::Base
	include ActiveMerchant::Shipping
	#	arbitrary restrictions
#	validates_length_of :carrier, :minimum => 3
	validates_length_of :tracking_number, :minimum => 3

	@@fedex = FedEx.new(YAML::load(ERB.new(IO.read('config/fed_ex.yml')).result)[::RAILS_ENV])

	def update_status
		begin
#	:test => true is needed in test and development
#	don't know what happens in production
			tracking_info = @@fedex.find_tracking_info(tracking_number, :test => true)
			self.update_attribute(:status, tracking_info.latest_event.name)
		rescue
			self.update_attribute(:status, "Update failed")
		end
	end

end

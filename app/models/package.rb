require 'active_shipping'
#	acts_as_trackable
class Package < ActiveRecord::Base
	include ActiveMerchant::Shipping
	acts_as_trackable

	#	Without defining the class_name, rails tries to use ...
	#		ActiveMerchant::Shipping::ShipmentEvent
	#	which seems really stupid.  Of course, I did just
	#	include ActiveMerchant::Shipping so, perhaps I brought
	#	it on myself by using this name.
#	has_many :shipment_events, :class_name => "::ShipmentEvent"

	#	arbitrary restrictions
#	validates_length_of :carrier, :minimum => 3
#	validates_length_of :tracking_number, :minimum => 3
#	validates_uniqueness_of :tracking_number

#	attr_accessible :tracking_number

	@@fedex = FedEx.new(YAML::load(ERB.new(IO.read('config/fed_ex.yml')).result)[::RAILS_ENV])
	@@packages_updated = "#{RAILS_ROOT}/packages_updated.#{RAILS_ENV}"

	named_scope :delivered, :conditions => [
		'status LIKE ?', 'Delivered%'
	]

	named_scope :undelivered, :conditions => [
		'status IS NULL OR status NOT LIKE ?', 'Delivered%'
	]

#	before_create :update_status

	def update_status
		begin
			#	:test => true is NEEDED in test and development
			#	don't know what happens in production
			#	I'm pretty sure that I'll need a "production" key
			#	to remove the :test => true.  I don't know if
			#	the results will be any different.  I doubt it.
			tracking_info = @@fedex.find_tracking_info(tracking_number, 
				:test => true)

			tracking_info.shipment_events.each do |event|
				unless self.tracks.exists?( :time => event.time )
					self.tracks.create!({
						:time  => event.time,
						:name  => event.name,
						:city  => event.location.city,
						:state => event.location.state,
						:zip   => event.location.zip
					})
				end
			end

			#	All the statuses that I've found (but may be others) ...
			#	Shipment information sent to FedEx
			#	Picked up
			#	Arrived at FedEx location
			#	Departed FedEx location
			#	At local FedEx facility
			#	On FedEx vehicle for delivery
			#	Delivered
			event = tracking_info.latest_event
			self.update_attribute(:status, 
				"#{event.name} at #{event.location.city}, " <<
					"#{event.location.state} on #{event.time}."
			)
		rescue
			self.update_attribute(:status, "Update failed")
		end
	end

	def self.update_undelivered
		self.undelivered.each do |package|
			package.update_status
		end
	end

	def delivered?
		status =~  /^Delivered/
	end

#
#	I don't really like this, but I needed a way for the background job 
#	to record when it last updated packages statuses so that the views
#	would be able to tell the user.  Creating a database table seemed
#	a bit extreme so I decided to just write it to a file.
#
	def self.last_updated
		if File.exists?(@@packages_updated)
			Time.parse(File.open(@@packages_updated,'r'){|f| f.read })
		else
			nil
		end
	end

	def self.just_updated
		File.open(@@packages_updated,'w'){|f| f.printf Time.now.to_s }
	end

	def self.packages_updated
		@@packages_updated
	end

end

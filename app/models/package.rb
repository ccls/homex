require 'active_shipping'
#	Package acts_as_trackable
#
#	==	named_scopes (don't get parsed by rdoc???)
#	*	delivered
#	*	undelivered
class Package < ActiveRecord::Base
	include ActiveMerchant::Shipping
	acts_as_trackable

	@@fedex = FedEx.new(YAML::load(ERB.new(IO.read('config/fed_ex.yml')).result)[::RAILS_ENV])
	@@packages_updated = "#{RAILS_ROOT}/packages_updated.#{RAILS_ENV}"

	named_scope :delivered, :conditions => [
		'status LIKE ?', 'Delivered%'
	]

	named_scope :undelivered, :conditions => [
		'status IS NULL OR status NOT LIKE ?', 'Delivered%'
	]

#	before_create :update_status

	#	Contact FedEx and get all tracking info regarding
	#	the given package's tracking_number.
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

	#	Loop over all undelivered packages and recheck
	#	and update their status.
	def self.update_undelivered
		self.undelivered.each do |package|
			package.update_status
		end
	end

	#	Returns boolean of whether or not the package 
	#	status suggests that the package was delivered.
	def delivered?
		status =~  /^Delivered/
	end

#
#	I don't really like this, but I needed a way for the background job 
#	to record when it last updated packages statuses so that the views
#	would be able to tell the user.  Creating a database table seemed
#	a bit extreme so I decided to just write it to a file.
#

	#	Read the time contained in the packages_updated file
	#	used by both the app and the background process.
	def self.last_updated
		if File.exists?(@@packages_updated)
			Time.parse(File.open(@@packages_updated,'r'){|f| f.read })
		else
			nil
		end
	end

	#	Write the current time to the packages_updated file
	#	used by both the app and the background process.
	def self.just_updated
		File.open(@@packages_updated,'w'){|f| f.printf Time.now.to_s }
	end

	#	Returns the name of the file used to store the
	#	time that the package statuses were last updated 
	#	used by both the app and the background process.
	def self.packages_updated
		@@packages_updated
	end

end

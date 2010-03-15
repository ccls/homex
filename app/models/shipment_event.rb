class ShipmentEvent < ActiveRecord::Base
#	default_scope :order => :time
#	belongs_to :package
#
#	validates_presence_of :package_id
#	validates_presence_of :name
#	validates_presence_of :time
#	validates_uniqueness_of :time, :scope => :package_id
#
#	attr_accessible :name, :time, :city, :state	#, :location
#	attr_accessor :city, :state
#
#	before_save :combine_city_and_state
#
#	def combine_city_and_state
#		self.location = if city.blank? &&
#			state.blank?
#			#	city and state can be blank for events like
#			#		'Shipment information sent to FedEx'
#			"None"
#		else
#			[city,state].delete_if{|a|a.blank?}.join(', ')
#		end
#	end
	
end

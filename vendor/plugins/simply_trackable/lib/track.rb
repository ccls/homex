class Track < ActiveRecord::Base
	default_scope :order => :time
	belongs_to :trackable, 
		:polymorphic => true, 
		:touch => true,
		:counter_cache => true

	validates_presence_of :trackable_id
	validates_presence_of :trackable_type
	validates_presence_of :name
	validates_presence_of :time
	validates_uniqueness_of :time, :scope => [:trackable_id, :trackable_type]

	attr_accessible :name, :time, :city, :state, :zip, :location

	before_save :combine_city_and_state

	def combine_city_and_state
		if location.blank?
			self.location = if city.blank? && state.blank?
				#	city and state can be blank for events like
				#		'Shipment information sent to FedEx'
				"None"
			else
				[city,state].delete_if{|a|a.blank?}.join(', ')
			end
		end
	end
	
end

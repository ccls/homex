class ShipmentEvent < ActiveRecord::Base
	default_scope :order => :time
	belongs_to :package
	validates_presence_of :package_id
end

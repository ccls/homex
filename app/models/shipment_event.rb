class ShipmentEvent < ActiveRecord::Base
	default_scope :order => :time
	belongs_to :package

	validates_presence_of :package_id
	validates_presence_of :name
	validates_presence_of :time
	validates_uniqueness_of :time, :scope => :package_id
end

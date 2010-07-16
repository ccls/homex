class SampleKit < ActiveRecord::Base
	belongs_to :sample
	belongs_to :kit_package,  :class_name => 'Package'
	belongs_to :sample_package, :class_name => 'Package'

	delegate :sent_on,     :to => :kit_package
	delegate :received_on, :to => :sample_package

#	validates_uniqueness_of :kit_package_id,  :allow_nil => true
#	validates_uniqueness_of :sample_package_id, :allow_nil => true
	validates_uniqueness_of :sample_id, :allow_nil => true

	accepts_nested_attributes_for :kit_package
	accepts_nested_attributes_for :sample_package

	def status
		status = case
			when sample_package.status == 'Delivered' then 'Received'
			when sample_package.status == 'Transit' then 'Returned'
			when kit_package.status == 'Delivered' then 'Delivered'
			when kit_package.status == 'Transit' then 'Shipped'
			else 'New'
		end
	end

end

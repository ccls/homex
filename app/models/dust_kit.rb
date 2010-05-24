class DustKit < ActiveRecord::Base
	belongs_to :subject
	belongs_to :kit_package,  :class_name => 'Package'
	belongs_to :dust_package, :class_name => 'Package'

	accepts_nested_attributes_for :kit_package
	accepts_nested_attributes_for :dust_package

	def status
		status = case
			when dust_package.status == 'Delivered' then 'Received'
			when dust_package.status == 'Transit' then 'Returned'
			when kit_package.status == 'Delivered' then 'Delivered'
			when kit_package.status == 'Transit' then 'Shipped'
			else 'New'
		end
	end

end

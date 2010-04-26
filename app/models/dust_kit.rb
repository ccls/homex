class DustKit < ActiveRecord::Base
	belongs_to :subject
	belongs_to :kit_package,  :class_name => 'Package'
	belongs_to :dust_package, :class_name => 'Package'

	accepts_nested_attributes_for :kit_package
	accepts_nested_attributes_for :dust_package

end

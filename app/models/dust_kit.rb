class DustKit < ActiveRecord::Base
	belongs_to :subject
	belongs_to :kit_package,  :class_name => 'Package'
	belongs_to :dust_package, :class_name => 'Package'
end

class Transfer < ActiveRecord::Base
#	belongs_to :aliquot
	belongs_to :from_organization,
		:class_name => "Organization"
	belongs_to :to_organization,
		:class_name => "Organization"

	validates_presence_of :from_organization_id
	validates_presence_of :to_organization_id
end

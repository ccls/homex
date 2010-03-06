class Transfer < ActiveRecord::Base
	belongs_to :aliquot
	belongs_to :from_organization,
		:class_name => "Organization"
	belongs_to :to_organization,
		:class_name => "Organization"

	validates_presence_of :aliquot_id
	validates_presence_of :from_organization_id
	validates_presence_of :to_organization_id

	before_save :update_aliquot_owner

	def to(organization)
		self.to_organization = organization
		self
	end

protected

	def update_aliquot_owner
		self.aliquot.update_attribute(:owner, self.to_organization)
	end

end


#	It would not surprise me if sent_on and received_on are added

#	This could also have a tracking_number and be tracked via active_shipping

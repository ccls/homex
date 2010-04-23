#	==	requires
#	*	aliquot_id
#	*	from_organization_id
#	*	to_organization_id
class Transfer < ActiveRecord::Base
	belongs_to :aliquot
	belongs_to :from_organization,
		:class_name => "Organization"
	belongs_to :to_organization,
		:class_name => "Organization"

	validates_presence_of :aliquot_id
	validate              :valid_aliquot_id
	validates_presence_of :from_organization_id
	validate              :valid_from_organization_id
	validates_presence_of :to_organization_id
	validate              :valid_to_organization_id

	before_save :update_aliquot_owner

	#	Associate the given transfer "to" an #Organization
	def to(organization)
		self.to_organization = organization
		self
	end

protected

	#	Set associated aliquot's owner to the receiving #Organization.
	def update_aliquot_owner
		self.aliquot.update_attribute(:owner, self.to_organization)
	end

	def valid_aliquot_id
		errors.add(:aliquot_id,'is invalid') unless Aliquot.exists?(aliquot_id)
	end

	def valid_from_organization_id
		errors.add(:from_organization_id,'is invalid') unless Organization.exists?(from_organization_id)
	end

	def valid_to_organization_id
		errors.add(:to_organization_id,'is invalid') unless Organization.exists?(to_organization_id)
	end

end


#	It would not surprise me if sent_on and received_on are added

#	This could also have a tracking_number and be tracked via active_shipping

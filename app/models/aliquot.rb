class Aliquot < ActiveRecord::Base
	belongs_to :sample
	belongs_to :unit
	belongs_to :aliquot_sample_format
	belongs_to :owner, :class_name => "Organization"
	has_many :transfers

	validates_presence_of :sample_id
	validates_presence_of :unit_id
	validates_presence_of :owner_id


	def transfer_to(org)
		organization = Organization.find(org)
		Aliquot.transaction do
			self.transfer.to(organization).save!
			self.owner = organization
			self.save!
		end
	end

protected

	def transfer
		Transfer.new({
			:aliquot_id => self.id,
			:from_organization_id => self.owner_id
		})
	end

end

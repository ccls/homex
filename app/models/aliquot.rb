class Aliquot < ActiveRecord::Base
	belongs_to :sample
	belongs_to :unit
	belongs_to :aliquot_sample_format
	belongs_to :owner, :class_name => "Organization", :counter_cache => true
	has_many :transfers

	validates_presence_of :sample_id
	validates_presence_of :unit_id
	validates_presence_of :owner_id

	def transfer_to(org)
		organization = Organization.find(org)
		#	I don't think that the transaction is necessary
		#	but I also don't think that it will hurt.
		Aliquot.transaction do
			#	wrap this in a transaction because
			#	we don't want the aliquot.owner being
			#	out of sync with the last transfer.to
			self.transfer.to(organization).save!
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

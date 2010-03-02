class Aliquot < ActiveRecord::Base
	belongs_to :sample
	belongs_to :unit
	belongs_to :aliquot_sample_format
#	belongs_to :aliquoter, :class_name => "Organization"
	belongs_to :owner, :class_name => "Organization", :counter_cache => true
	has_many :transfers
#	has_one :last_transfer, :class_name => 'Transfer', 
#		:order => 'created_at'

	validates_presence_of :sample_id
	validates_presence_of :unit_id
#	validates_presence_of :aliquoter_id
	validates_presence_of :owner_id

	#	works except initially as there is no transfer
	#	so need to use try and the ||
	#	Could change owner relationship to creator or aliquoter
#
#	the initial relationship could be delegated to sample
#		and then we can remove owner/creator/aliquoter from Aliquot
#		altogether.  (Sample doesn't currently have that yet.)
#
#	def owner
#		self.last_transfer.try(:to_organization) || self.aliquoter
#	end
#
#	def owner_id
#		self.owner.id
#	end

#	I am still prefering obtaining the owner from the last transfer
#	and changing owner_id to aliquoter_id and then can remove
#	the transaction as there is only 1 change.
#	Doing this seems to break the concept of organization.aliquots
#		(or at least complicate the hell out of it)


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

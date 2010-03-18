#	==	requires
#	*	name ( unique and > 3 chars )
class Organization < ActiveRecord::Base

	has_many :aliquots, :foreign_key => 'owner_id'

	has_many :incoming_transfers, 
		:foreign_key => 'to_organization_id', 
		:class_name => 'Transfer'
	has_many :outgoing_transfers, 
		:foreign_key => 'from_organization_id',
		:class_name => 'Transfer'

#	has_many :samples

	validates_length_of :name, :minimum => 4
	validates_uniqueness_of :name
end

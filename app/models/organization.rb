#	==	requires
#	*	name ( unique and > 3 chars )
class Organization < ActiveRecord::Base
	acts_as_list

	has_many :aliquots, :foreign_key => 'owner_id'

	has_many :incoming_transfers, 
		:foreign_key => 'to_organization_id', 
		:class_name => 'Transfer'
	has_many :outgoing_transfers, 
		:foreign_key => 'from_organization_id',
		:class_name => 'Transfer'

	has_many :hospitals
	has_many :patients

#	how
#	has_many :samples
#	this is not clear in my UML diagram

	validates_length_of     :code, :minimum => 4
	validates_uniqueness_of :code
	validates_length_of     :name, :minimum => 4
	validates_uniqueness_of :name

	def to_s
		name
	end

end

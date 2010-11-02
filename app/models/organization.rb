#	==	requires
#	*	name ( unique and > 3 chars )
class Organization < ActiveRecord::Base
	acts_as_list

	belongs_to :person

	has_many :aliquots, :foreign_key => 'owner_id'

	has_many :incoming_transfers, 
		:foreign_key => 'to_organization_id', 
		:class_name => 'Transfer'
	has_many :outgoing_transfers, 
		:foreign_key => 'from_organization_id',
		:class_name => 'Transfer'

	has_many :hospitals
	has_many :patients

	validates_uniqueness_of :code
	validates_uniqueness_of :name
	validates_length_of :code, :name, :in => 4..250

	#	Returns name
	def to_s
		name
	end

end

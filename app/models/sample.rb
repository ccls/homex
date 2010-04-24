#	==	requires
#	*	subject_id
#	*	unit_id
class Sample < ActiveRecord::Base
	belongs_to :aliquot_sample_format
	belongs_to :sample_subtype
	belongs_to :subject
	belongs_to :unit
	has_many :aliquots

#	how
#	belongs_to :organization
#	this is not clear in my UML diagram

	validates_presence_of :subject, :unit

end

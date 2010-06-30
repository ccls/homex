#	==	requires
#	*	subject_id
#	*	unit_id
class Sample < ActiveRecord::Base
	belongs_to :aliquot_sample_format
	belongs_to :sample_subtype
	belongs_to :subject
	belongs_to :unit
	has_many :aliquots
	has_and_belongs_to_many :projects

#	how
#	belongs_to :organization
#	this is not clear in my UML diagram

	validates_presence_of :subject_id, :unit_id,
		:subject, :unit

end

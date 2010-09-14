#	==	requires
#	*	subject_id
#	*	unit_id
class Sample < ActiveRecord::Base
	belongs_to :aliquot_sample_format
	belongs_to :sample_type
	belongs_to :subject
	belongs_to :unit
	has_many :aliquots
	has_and_belongs_to_many :projects
	has_one :sample_kit

#	how
#	belongs_to :organization
#	this is not clear in my UML diagram

#	validates_presence_of :unit_id, :unit
	validates_presence_of :sample_type_id, :sample_type
	validates_presence_of :subject_id, :subject

end

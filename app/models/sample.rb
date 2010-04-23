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

	validates_belongs_to_exists :subject_id, :unit_id

#	validates_presence_of :subject_id
#	validate              :valid_subject_id
#	validates_presence_of :unit_id
#	validate              :valid_unit_id
#
#protected
#
#	def valid_subject_id
#		errors.add(:subject_id,'is invalid') unless Subject.exists?(subject_id)
#	end
#
#	def valid_unit_id
#		errors.add(:unit_id,'is invalid') unless Unit.exists?(unit_id)
#	end

end

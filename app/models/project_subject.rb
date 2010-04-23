#	==	requires
#	*	subject_id
#	*	study_event_id
class ProjectSubject < ActiveRecord::Base
	belongs_to :subject
	belongs_to :ineligible_reason
	belongs_to :refusal_reason
	belongs_to :study_event

#	validates_presence_of :subject_id
#	validate              :valid_subject_id
#	validates_presence_of :study_event_id
#	validate              :valid_study_event_id

	validates_belongs_to_exists :subject_id, :study_event_id

#protected
#
#	def valid_subject_id
#		errors.add(:subject_id,'is invalid') unless Subject.exists?(subject_id)
#	end
#
#	def valid_study_event_id
#		errors.add(:study_event_id,'is invalid') unless StudyEvent.exists?(study_event_id)
#	end
#
end

#	==	requires
#	*	study_event_id
#	*	subject_id
class StudyEventEligibility < ActiveRecord::Base
	belongs_to :study_event
	belongs_to :subject

	validates_belongs_to_exists :study_event_id, :subject_id

#	validates_presence_of :study_event_id
#	validate              :valid_study_event_id
#	validates_presence_of :subject_id
#	validate              :valid_subject_id
#
#protected
#
#	def valid_study_event_id
#		errors.add(:study_event_id,'is invalid') unless StudyEvent.exists?(study_event_id)
#	end
#
#	def valid_subject_id
#		errors.add(:subject_id,'is invalid') unless Subject.exists?(subject_id)
#	end

end

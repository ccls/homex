#	==	belongs_to 
#	*	#Subject
#	*	#IneligibleReason
#	*	#RefusalReason
#	*	#StudyEvent
#
#	==	requires
#	*	subject_id
#	*	study_event_id
class ProjectSubject < ActiveRecord::Base
	belongs_to :subject
	belongs_to :ineligible_reason
	belongs_to :refusal_reason
	belongs_to :study_event

	validates_presence_of :subject_id
	validates_presence_of :study_event_id
end

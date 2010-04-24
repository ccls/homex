#	==	requires
#	*	study_event_id
#	*	subject_id
class StudyEventEligibility < ActiveRecord::Base
	belongs_to :study_event
	belongs_to :subject

	validates_presence_of :study_event, :subject

end

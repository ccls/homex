#	==	belongs_to
#	*	#SubjectType
#	*	#Race
#	==	has_many
#	*	#Sample
#	*	#ProjectSubject
#	*	#OperationalEvent
#	*	#Residence
#	*	#InterviewEvent
#	*	#StudyEventEligibility
#	==	has_one
#	*	#Pii
class Subject < ActiveRecord::Base
	belongs_to :subject_type
	belongs_to :race
	has_many :samples
	has_many :project_subjects
	has_many :operational_events
	has_many :residences
	has_many :interview_events
	has_many :study_event_eligibilities
	has_one :pii

	validates_presence_of :subject_type_id
	validates_presence_of :race_id
end

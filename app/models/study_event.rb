class StudyEvent < ActiveRecord::Base
	has_many :operational_event_types
	has_many :interview_types
#	has_many :study_event_eligibilities
#	has_many :study_events_subjects
	validates_length_of :description, :minimum => 4
end

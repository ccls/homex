class Subject < ActiveRecord::Base
	belongs_to :subject_type
	belongs_to :race
	has_many :samples
	has_many :project_subjects
	has_many :operational_events
	has_many :residences
	has_many :interview_events
	has_many :study_event_eligibilities
end

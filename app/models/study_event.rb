class StudyEvent < ActiveRecord::Base
	acts_as_list
	has_many :operational_event_types
	has_many :interview_types
	has_many :project_subjects
	has_many :study_event_eligibilities
	validates_length_of :description, :minimum => 4
	validates_uniqueness_of :description
	named_scope :list, :order => :position
end

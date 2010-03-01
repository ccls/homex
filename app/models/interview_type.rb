class InterviewType < ActiveRecord::Base
	belongs_to :study_event
	has_many :interview_versions
	validates_length_of :description, :minimum => 4
	validates_presence_of :study_event_id
end

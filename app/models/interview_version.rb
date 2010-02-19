class InterviewVersion < ActiveRecord::Base
	belongs_to :interview_type
	belongs_to :interview_event

	validates_length_of :description, :minimum => 4
end

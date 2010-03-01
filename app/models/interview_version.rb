class InterviewVersion < ActiveRecord::Base
	belongs_to :interview_type
	belongs_to :interview_event
	validates_length_of :description, :minimum => 4
	validates_presence_of :interview_type_id
	validates_presence_of :interview_event_id
end

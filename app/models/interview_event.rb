class InterviewEvent < ActiveRecord::Base
	belongs_to :address
	belongs_to :interviewer
	belongs_to :interview_version
#	belongs_to :subject
end

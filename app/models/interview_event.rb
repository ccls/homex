class InterviewEvent < ActiveRecord::Base
	belongs_to :address
	belongs_to :interviewer, :class_name => 'Person'
	has_many :interview_versions
#	belongs_to :interview_version
#	belongs_to :subject
end

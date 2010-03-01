class InterviewEvent < ActiveRecord::Base
	belongs_to :address
	belongs_to :interviewer, :class_name => 'Person'
	belongs_to :subject
	has_many :interview_versions
end

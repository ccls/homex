#	==	requires
#	*	address_id
#	*	interviewer_id
#	*	subject_id
class InterviewEvent < ActiveRecord::Base
	belongs_to :address
	belongs_to :interviewer, :class_name => 'Person'
	belongs_to :subject
	has_many :interview_versions
	has_many :operational_event_types

	validates_presence_of :address, :subject, :interviewer

end

class InterviewEvent < ActiveRecord::Base
	belongs_to :address
	belongs_to :interviewer, :class_name => 'Person'
	belongs_to :subject
	has_many :interview_versions
	has_many :operational_event_types

	validates_presence_of :address_id
	validates_presence_of :interviewer_id
	validates_presence_of :subject_id
end

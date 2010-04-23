#	==	requires
#	*	description ( unique and > 3 chars )
#	*	study_event_id
#	*	interview_event_id
class OperationalEventType < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :operational_events
	belongs_to :study_event
	belongs_to :interview_event

	validates_length_of :description, :minimum => 4
	validates_presence_of :study_event_id
	validate              :valid_study_event_id
	validates_presence_of :interview_event_id
	validate              :valid_interview_event_id
	validates_uniqueness_of :description

protected

	def valid_interview_event_id
		errors.add(:interview_event_id,'is invalid') unless InterviewEvent.exists?(interview_event_id)
	end

	def valid_study_event_id
		errors.add(:study_event_id,'is invalid') unless StudyEvent.exists?(study_event_id)
	end

end

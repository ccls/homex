#	==	belongs_to
#	*	#InterviewType
#	*	#InterviewEvent
#
#	==	requires
#	*	description ( unique and > 3 chars )
#	*	interview_type_id
#	*	interview_event_id
class InterviewVersion < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	belongs_to :interview_type
	belongs_to :interview_event

	validates_length_of :description, :minimum => 4
	validates_presence_of :interview_type_id
	validates_presence_of :interview_event_id
	validates_uniqueness_of :description
end

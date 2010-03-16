#	==	belongs_to
#	*	#Subject
#	*	#OperationalEventType
#
#	==	requires
#	*	subject_id
#	*	operational_event_type_id
class OperationalEvent < ActiveRecord::Base
	belongs_to :subject
	belongs_to :operational_event_type

	validates_presence_of :subject_id
	validates_presence_of :operational_event_type_id
end

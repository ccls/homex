#	==	requires
#	*	subject_id
#	*	operational_event_type_id
class OperationalEvent < ActiveRecord::Base
	belongs_to :subject
	belongs_to :operational_event_type

	validates_presence_of :subject, :operational_event_type

end

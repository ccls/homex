#	==	requires
#	*	operational_event_type_id
class OperationalEvent < ActiveRecord::Base
	acts_as_list
	belongs_to :enrollment

#	belongs_to :subject
#	validates_presence_of :subject_id, :operational_event_type_id,
#		:subject, :operational_event_type

	belongs_to :operational_event_type
	validates_presence_of :operational_event_type_id,
		:operational_event_type
end

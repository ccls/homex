#	==	requires
#	*	subject_id
#	*	operational_event_type_id
class OperationalEvent < ActiveRecord::Base
	belongs_to :subject
	belongs_to :operational_event_type

	validates_presence_of :subject_id
	validate              :valid_subject_id
	validates_presence_of :operational_event_type_id
	validate              :valid_operational_event_type_id

protected

	def valid_operational_event_type_id
		errors.add(:operational_event_type_id,'is invalid') unless OperationalEventType.exists?(operational_event_type_id)
	end

	def valid_subject_id
		errors.add(:subject_id,'is invalid') unless Subject.exists?(subject_id)
	end

end

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

#	validates_presence_of :address_id
#	validate              :valid_address_id
	validates_presence_of :interviewer_id
	validate              :valid_interviewer_id
#	validates_presence_of :subject_id
#	validate              :valid_subject_id

	validates_belongs_to_exists :address_id, :subject_id

protected

#	def valid_address_id
#		errors.add(:address_id,'is invalid') unless Address.exists?(address_id)
#	end

	def valid_interviewer_id
		errors.add(:interviewer_id,'is invalid') unless Person.exists?(interviewer_id)
	end

#	def valid_subject_id
#		errors.add(:subject_id,'is invalid') unless Subject.exists?(subject_id)
#	end

end

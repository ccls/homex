#	==	requires
#	*	address_id
#	*	interviewer_id
#	*	identifier_id
class Interview < ActiveRecord::Base
	belongs_to :identifier
	belongs_to :address
	belongs_to :interviewer, :class_name => 'Person'
	belongs_to :interview_version
	belongs_to :interview_method
	belongs_to :language

#	has_many :operational_event_types

#	validates_presence_of :identifier

end

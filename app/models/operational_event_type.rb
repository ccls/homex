#	==	requires
#	*	description ( unique and > 3 chars )
#	*	project
#	*	interview_event_id
class OperationalEventType < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :operational_events
	belongs_to :project
	belongs_to :interview_event

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

	validates_presence_of :interview_event, :project

end

class OperationalEventType < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :operational_events
	belongs_to :study_event
	belongs_to :interview_event

	validates_length_of :description, :minimum => 4
	validates_presence_of :study_event_id
	validates_presence_of :interview_event_id
	validates_uniqueness_of :description
end

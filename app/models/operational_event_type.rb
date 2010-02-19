class OperationalEventType < ActiveRecord::Base
	has_many :operational_events
	belongs_to :study_event

#	belongs_to :interview_event
#		MISSING FOREIGN KEY

	validates_length_of :description, :minimum => 4
end

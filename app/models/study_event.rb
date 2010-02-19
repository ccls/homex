class StudyEvent < ActiveRecord::Base
	has_many :operational_event_types
	validates_length_of :description, :minimum => 4
end

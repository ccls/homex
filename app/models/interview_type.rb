class InterviewType < ActiveRecord::Base
	belongs_to :study_event
	validates_length_of :description, :minimum => 4
end

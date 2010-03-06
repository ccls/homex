class InterviewType < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	belongs_to :study_event
	has_many :interview_versions

	validates_length_of :description, :minimum => 4
	validates_presence_of :study_event_id
	validates_uniqueness_of :description
end

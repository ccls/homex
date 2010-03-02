class InterviewType < ActiveRecord::Base
	acts_as_list
	belongs_to :study_event
	has_many :interview_versions
	validates_length_of :description, :minimum => 4
	validates_presence_of :study_event_id
	validates_uniqueness_of :description
	named_scope :list, :order => :position
end

#	==	requires
#	*	description ( unique and > 3 chars )
#	*	study_event_id
class InterviewType < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	belongs_to :study_event
	has_many :interview_versions

	validates_length_of :description, :minimum => 4
#	validates_presence_of :study_event_id
#	validate              :valid_study_event_id
	validates_uniqueness_of :description

	validates_belongs_to_exists :study_event_id

protected

#	def valid_study_event_id
#		errors.add(:study_event_id,'is invalid') unless StudyEvent.exists?(study_event_id)
#	end

end

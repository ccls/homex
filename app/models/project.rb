#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
class Project < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :operational_event_types
	has_many :interview_types
	has_many :project_subjects
	has_many :subjects, :through => :project_subjects

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description
end

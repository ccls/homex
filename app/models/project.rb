#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
class Project < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_and_belongs_to_many :samples
	has_many :operational_event_types
	has_many :interview_types
	has_many :enrollments
	has_many :subjects, :through => :enrollments
	has_many :instruments

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

	def self.unenrolled_projects(subject)
		Project.all(
			:joins => "LEFT JOIN enrollments ON " <<
				"projects.id = enrollments.project_id AND " <<
				"enrollments.subject_id = #{subject.id}",
			:conditions => [ "enrollments.subject_id IS NULL" ])
	end

	class NotFound < StandardError; end

	def self.[](code)
		find_by_code(code) #|| raise(NotFound)
	end

end

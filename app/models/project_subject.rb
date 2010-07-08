#	==	requires
#	*	subject_id
#	*	project
class ProjectSubject < ActiveRecord::Base
	belongs_to :subject
	belongs_to :ineligible_reason
	belongs_to :refusal_reason
	belongs_to :project

	validates_uniqueness_of :project_id, :scope => [:subject_id]
	validates_presence_of :subject_id, :project_id,
		:subject, :project

end

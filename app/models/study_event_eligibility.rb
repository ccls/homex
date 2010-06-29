#	==	requires
#	*	project
#	*	subject_id
class StudyEventEligibility < ActiveRecord::Base
	belongs_to :project
	belongs_to :subject

	validates_presence_of :project, :subject

end

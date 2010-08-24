#	==	requires
#	*	subject_id
#	*	project
class Enrollment < ActiveRecord::Base
	belongs_to :subject
	belongs_to :ineligible_reason
	belongs_to :refusal_reason
	belongs_to :project

	validates_uniqueness_of :project_id, :scope => [:subject_id]
	validates_presence_of :subject_id, :project_id,
		:subject, :project

	validate :completed_on_is_valid
	validate :consented_on_is_valid
	validate :completed_on_is_in_the_past
	validate :consented_on_is_in_the_past

	stringify_date :completed_on, :consented_on

protected

	def completed_on_is_valid
		errors.add(:completed_on, "is invalid") if completed_on_invalid?
	end

	def consented_on_is_valid
		errors.add(:consented_on, "is invalid") if consented_on_invalid?
	end

	def completed_on_is_in_the_past
		if !completed_on.blank? && Time.now < completed_on
			errors.add(:completed_on, "is in the future.") 
		end
	end

	def consented_on_is_in_the_past
		if !consented_on.blank? && Time.now < consented_on
			errors.add(:consented_on, "is in the future.") 
		end
	end

end

#	==	requires
#	*	subject_id
#	*	project
class Enrollment < ActiveRecord::Base
	belongs_to :subject
	belongs_to :ineligible_reason
	belongs_to :refusal_reason
	belongs_to :document_version
	belongs_to :project

	validates_uniqueness_of :project_id, :scope => [:subject_id]
	validates_presence_of :subject_id, :project_id,
		:subject, :project

	validates_presence_of :ineligible_reason,
		:unless => :is_eligible?

	validates_presence_of :ineligible_reason_specify,
		:if => :ineligible_reason_is_other?

	validates_presence_of :reason_not_chosen,
		:unless => :is_chosen?

	validates_presence_of :refusal_reason,
		:unless => :consented?

	validates_presence_of :consented_on,
		:if => :consented?

	validates_presence_of :other_refusal_reason,
		:if => :refusal_reason_is_other?

	validates_presence_of :terminated_reason,
		:if => :terminated_participation?

	validates_presence_of :completed_on,
		:if => :is_complete?

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
			errors.add(:completed_on, "is in the future and must be in the past.") 
		end
	end

	def consented_on_is_in_the_past
		if !consented_on.blank? && Time.now < consented_on
			errors.add(:consented_on, "is in the future and must be in the past.") 
		end
	end

	def ineligible_reason_is_other?
		ineligible_reason.try(:code) == 'other'
	end

	def refusal_reason_is_other?
		refusal_reason.try(:code) == 'other'
	end

end

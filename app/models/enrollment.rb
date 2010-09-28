#	==	requires
#	*	subject_id
#	*	project
class Enrollment < ActiveRecord::Base
	belongs_to :subject
	belongs_to :ineligible_reason
	belongs_to :refusal_reason
	belongs_to :document_version
	belongs_to :project
	has_many   :operational_events

	validates_uniqueness_of :project_id, :scope => [:subject_id]
	validates_presence_of :subject_id, :project_id,
		:subject, :project

	validates_presence_of :ineligible_reason,
		:message => 'required if ineligible',
		:if => :is_not_eligible?
	validates_absence_of :ineligible_reason,
		:message => 'not allowed if not ineligible',
		:unless => :is_not_eligible?

	validates_presence_of :ineligible_reason_specify,
		:if => :ineligible_reason_is_other?
	validates_absence_of :ineligible_reason_specify,
		:message => 'not allowed',
		:unless => :ineligible_reason_is_other?

	validates_presence_of :reason_not_chosen,
		:unless => :is_chosen?

	validates_presence_of :refusal_reason,
		:if => :not_consented?
	validates_absence_of :refusal_reason,
		:message => "not allowed with consent",
		:unless => :not_consented?

	validates_presence_of :consented_on,
		:message => 'required with consent',
		:if => :consented?
	validates_presence_of :consented_on,
		:message => 'required without consent',
		:if => :not_consented?
	validates_absence_of :consented_on,
		:message => 'not allowed with unknown consent',
		:if => :consent_unknown?
#	validate :consented_on_is_valid
	validate :consented_on_is_in_the_past

	validates_presence_of :other_refusal_reason,
		:if => :refusal_reason_is_other?
	validates_absence_of :other_refusal_reason,
		:message => "not allowed",
		:unless => :refusal_reason_is_other?

	validates_presence_of :terminated_reason,
		:if => :terminated_participation?
#	validates_absence_of :terminated_reason,
#		:unless => :terminated_participation?

	validates_presence_of :completed_on,
		:if => :is_complete?
	validates_absence_of :completed_on,
		:unless => :is_complete?
#	validate :completed_on_is_valid
	validate :completed_on_is_in_the_past

	validates_absence_of :document_version,
		:message => "not allowed with unknown consent",
		:if => :consent_unknown?

#	stringify_date :completed_on, :consented_on, :format => '%m/%d/%Y'

	before_save :create_enrollment_update,
		:if => :is_complete_changed?

	def is_eligible?
		is_eligible == 1
	end

	def is_not_eligible?
		is_eligible == 2
	end

	def is_chosen?
		is_chosen == 1
	end

	def consented?
		consented == 1
	end

	def not_consented?
		consented == 2
	end

	def consent_unknown?
		[nil,999].include?(consented)	#	not 1 or 2
	end

	def terminated_participation?
		terminated_participation == 1
	end

	def is_complete?
		is_complete == 1
	end

protected

#	def completed_on_is_valid
#		errors.add(:completed_on, "is invalid") if completed_on_invalid?
#	end
#
#	def consented_on_is_valid
#		errors.add(:consented_on, "is invalid") if consented_on_invalid?
#	end

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

	def create_enrollment_update
		operational_event_type, occurred_on = if( is_complete == YNDK[:yes] )
			[OperationalEventType['complete'], completed_on]
		elsif( is_complete_was == YNDK[:yes] )
			[OperationalEventType['reopened'], Date.today]
		else 
			[nil, nil]
		end
		unless operational_event_type.nil?
			operational_events << OperationalEvent.create!(
				:operational_event_type => operational_event_type,
				:occurred_on => occurred_on
			)
		end
	end

end

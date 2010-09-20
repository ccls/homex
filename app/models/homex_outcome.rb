# don't know exactly
class HomexOutcome < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	belongs_to :subject
	belongs_to :sample_outcome
	belongs_to :interview_outcome

#	validates_uniqueness_of :subject_id
#	validates_presence_of :subject_id, :subject

	# because subject accepts_nested_attributes for homex_outcome
	# we can't require subject_id on create
	validates_presence_of   :subject, :on => :update
	validates_uniqueness_of :subject_id, :allow_nil => true

	stringify_date :sample_outcome_on, :format => '%m/%d/%Y'
	stringify_date :interview_outcome_on, :format => '%m/%d/%Y'

	validates_presence_of :sample_outcome_on,
		:if => :sample_outcome_id?

	validates_presence_of :interview_outcome_on,
		:if => :interview_outcome_id?

	before_save :create_interview_outcome_update,
		:if => :interview_outcome_id_changed?

	before_save :create_sample_outcome_update,
		:if => :sample_outcome_id_changed?

	class NoHomeExposureEnrollment < StandardError; end

protected

	def create_interview_outcome_update
		operational_event_type = case interview_outcome 
			when InterviewOutcome.find_by_code('scheduled')
				OperationalEventType.find_by_code('scheduled')
			when InterviewOutcome.find_by_code('complete')
				OperationalEventType.find_by_code('iv_complete')
			else nil
		end
		unless operational_event_type.nil?
			raise NoHomeExposureEnrollment if subject.hx_enrollment.nil?
			subject.hx_enrollment.operational_events << OperationalEvent.create!(
				:operational_event_type => operational_event_type,
				:occurred_on => interview_outcome_on
			)
		end
	end

	def create_sample_outcome_update
		operational_event_type = case sample_outcome 
			when SampleOutcome.find_by_code('sent')
				OperationalEventType.find_by_code('kit_sent')
			when SampleOutcome.find_by_code('received')
				OperationalEventType.find_by_code('sample_received')
			when SampleOutcome.find_by_code('complete')
				OperationalEventType.find_by_code('sample_complete')
			else nil
		end
		unless operational_event_type.nil?
			raise NoHomeExposureEnrollment if subject.hx_enrollment.nil?
			subject.hx_enrollment.operational_events << OperationalEvent.create!(
				:operational_event_type => operational_event_type,
				:occurred_on => sample_outcome_on
			)
		end
	end

end

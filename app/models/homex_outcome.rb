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

	def to_s
		description
	end

end

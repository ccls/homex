#	==	requires
#	*	subject_id
#	*	unit_id
class Sample < ActiveRecord::Base
	belongs_to :aliquot_sample_format
	belongs_to :sample_type
	belongs_to :subject, :foreign_key => 'study_subject_id'
	belongs_to :unit
	has_many :aliquots
	has_and_belongs_to_many :projects
	has_one :sample_kit
	accepts_nested_attributes_for :sample_kit

	validates_presence_of :sample_type_id, :sample_type
	validates_presence_of :study_subject_id, :subject

	validates_presence_of :sent_to_subject_on, 
		:if => :received_by_ccls_on
	validates_presence_of :received_by_ccls_on, 
		:if => :sent_to_lab_on
	validates_presence_of :sent_to_lab_on, 
		:if => :received_by_lab_on
	validates_presence_of :received_by_lab_on, 
		:if => :aliquotted_on

	validates_complete_date_for :sent_to_subject_on,
		:received_by_ccls_on,
		:sent_to_lab_on,
		:received_by_lab_on,
		:aliquotted_on,
		:receipt_confirmed_on,
		:allow_nil => true

	validate :tracking_numbers_are_different
	validate :date_chronology

	#	Returns the parent of this sample type
	def sample_type_parent
		sample_type.parent
	end

	delegate :kit_package,    :to => :sample_kit, :allow_nil => true
	delegate :sample_package, :to => :sample_kit, :allow_nil => true

	#	Returns tracking number of the kit package
	def kit_tracking_number
		kit_package.try(:tracking_number)
	end

	#	Returns sent on of the kit package
	def kit_sent_on
		kit_package.try(:sent_on)
	end

	#	Returns received on of the kit package
	def kit_received_on
		kit_package.try(:received_on)
	end

	#	Returns tracking number of the sample package
	def sample_tracking_number
		sample_package.try(:tracking_number)
	end

	#	Returns sent on of the sample package
	def sample_sent_on
		sample_package.try(:sent_on)
	end

	#	Returns received on of the sample package
	def sample_received_on
		sample_package.try(:received_on)
	end

	before_save :update_sample_outcome

protected

	def tracking_numbers_are_different
		errors.add(:base, "Tracking numbers MUST be different.") if
			( kit_tracking_number == sample_tracking_number ) &&
			( !kit_tracking_number.blank? || !sample_tracking_number.blank? )
	end

	def date_chronology
		errors.add(:received_by_ccls_on,
			"must be after sent_to_subject_on") if
			( sent_to_subject_on && received_by_ccls_on ) &&
			( sent_to_subject_on >  received_by_ccls_on )

		errors.add(:sent_to_lab_on,
			"must be after received_by_ccls_on") if
			( received_by_ccls_on && sent_to_lab_on ) &&
			( received_by_ccls_on >  sent_to_lab_on )

		errors.add(:received_by_lab_on,
			"must be after sent_to_lab_on") if
			( sent_to_lab_on && received_by_lab_on ) &&
			( sent_to_lab_on >  received_by_lab_on )

		errors.add(:aliquotted_on,
			"must be after received_by_lab_on") if
			( received_by_lab_on && aliquotted_on ) &&
			( received_by_lab_on >  aliquotted_on )
	end

	def update_sample_outcome
		if subject.hx_enrollment
			ho = subject.homex_outcome || subject.create_homex_outcome
			so,date = if sent_to_lab_on_changed? && !sent_to_lab_on.nil?
				[SampleOutcome['lab'], sent_to_lab_on ]
			elsif received_by_ccls_on_changed? && !received_by_ccls_on.nil?
				[SampleOutcome['received'], received_by_ccls_on ]
			elsif sent_to_subject_on_changed? && !sent_to_subject_on.nil?
				[SampleOutcome['sent'], sent_to_subject_on ]
			end
			ho.update_attributes({
				:sample_outcome => so,
				:sample_outcome_on => date }) if so
		end
	end

end

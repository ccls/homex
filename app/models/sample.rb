#	==	requires
#	*	subject_id
#	*	unit_id
class Sample < ActiveRecord::Base
	belongs_to :aliquot_sample_format
	belongs_to :sample_type
	belongs_to :subject
	belongs_to :unit
	has_many :aliquots
	has_and_belongs_to_many :projects
	has_one :sample_kit
	accepts_nested_attributes_for :sample_kit

	validates_presence_of :sample_type_id, :sample_type
	validates_presence_of :subject_id, :subject

	validates_complete_date_for :sent_to_subject_on,
		:received_by_ccls_on,
		:sent_to_lab_on,
		:received_by_lab_on,
		:aliquotted_on,
		:receipt_confirmed_on,
		:allow_nil => true

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

	validate :tracking_numbers_are_different

	def tracking_numbers_are_different
		errors.add(:base, "Tracking numbers MUST be different.") if
			( kit_tracking_number == sample_tracking_number ) &&
			( !kit_tracking_number.blank? || !sample_tracking_number.blank? )
	end

end

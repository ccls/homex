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

#	how
#	belongs_to :organization
#	this is not clear in my UML diagram

#	validates_presence_of :unit_id, :unit
	validates_presence_of :sample_type_id, :sample_type
	validates_presence_of :subject_id, :subject

	stringify_date :sent_to_subject_on, 
		:received_by_ccls_on, 
		:sent_to_lab_on, 
		:received_by_lab_on, 
		:aliquotted_on, 
		:format => '%m/%d/%Y'

	def sample_type_parent
		sample_type.parent
	end

	def kit_tracking_number
		try(:sample_kit).try(:kit_package).try(:tracking_number)
	end

	def kit_sent_on
		try(:sample_kit).try(:kit_package).try(:sent_on)
	end

	def kit_received_on
		try(:sample_kit).try(:kit_package).try(:received_on)
	end

	def sample_tracking_number
		try(:sample_kit).try(:sample_package).try(:tracking_number)
	end

	def sample_sent_on
		try(:sample_kit).try(:sample_package).try(:sent_on)
	end

	def sample_received_on
		try(:sample_kit).try(:sample_package).try(:received_on)
	end

	validate :tracking_numbers_are_different

	def tracking_numbers_are_different
		errors.add(:base, "Tracking numbers MUST be different.") if
			( kit_tracking_number == sample_tracking_number ) &&
			( !kit_tracking_number.blank? || !sample_tracking_number.blank? )
	end

end

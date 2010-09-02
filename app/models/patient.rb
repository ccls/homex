# Patient related subject info.
class Patient < ActiveRecord::Base
	belongs_to :subject
	belongs_to :organization
	belongs_to :diagnosis

#	# because subject accepts_nested_attributes for patient
#	# we can't require subject_id on create
#	validates_presence_of   :subject, :on => :update
#	validates_uniqueness_of :subject_id, :allow_nil => true

	validates_presence_of :subject_id, :subject
	validates_uniqueness_of :subject_id

	stringify_date :diagnosis_date
	validate :diagnosis_date_is_valid
	validate :subject_is_case

protected

	def diagnosis_date_is_valid
		errors.add(:diagnosis_date, "is invalid") if diagnosis_date_invalid?
	end

	def subject_is_case
		if subject and subject.subject_type.code != 'Case'
		errors.add(:subject,"must be case to have patient info")
		end
	end

end

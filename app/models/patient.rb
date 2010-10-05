# Patient related subject info.
class Patient < ActiveRecord::Base
	belongs_to :subject
	belongs_to :organization
	belongs_to :diagnosis

	validates_presence_of :subject_id, :subject
	validates_uniqueness_of :subject_id

	validate :diagnosis_date_is_in_the_past
	validate :diagnosis_date_is_after_dob
	validate :subject_is_case

	validates_complete_date_for :diagnosis_date,
		:allow_nil => true

protected

	def diagnosis_date_is_in_the_past
		if !diagnosis_date.blank? && Time.now < diagnosis_date
			errors.add(:diagnosis_date, 
				"is in the future and must be in the past.") 
		end
	end

	def diagnosis_date_is_after_dob
		if !diagnosis_date.blank? && 
			!subject.blank? && 
			!subject.dob.blank? && 
			diagnosis_date < subject.dob
			errors.add(:diagnosis_date, "is before subject's dob.") 
		end
	end

	def subject_is_case
		if subject and subject.subject_type.code != 'Case'
		errors.add(:subject,"must be case to have patient info")
		end
	end

end

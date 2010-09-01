# Patient related subject info.
class Patient < ActiveRecord::Base
	belongs_to :subject
	belongs_to :organization
	belongs_to :diagnosis

	# because subject accepts_nested_attributes for patient
	# we can't require subject_id on create
	validates_presence_of   :subject, :on => :update
	validates_uniqueness_of :subject_id, :allow_nil => true

	stringify_date :diagnosis_date
	validate :diagnosis_date_is_valid

protected

	def diagnosis_date_is_valid
		errors.add(:diagnosis_date, "is invalid") if diagnosis_date_invalid?
	end

end

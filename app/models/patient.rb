class Patient < ActiveRecord::Base
	belongs_to :subject

	# because subject accepts_nested_attributes for patient
	# we can't require subject_id on create
	validates_presence_of   :subject_id, :on => :update
	validate                :valid_subject_id
	validates_uniqueness_of :subject_id, :allow_nil => true

protected

	def valid_subject_id
		if !self.new_record? && !Subject.exists?(subject_id)
			errors.add(:subject_id,'is invalid')
		end
	end

end

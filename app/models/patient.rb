class Patient < ActiveRecord::Base
	belongs_to :subject

	# because subject accepts_nested_attributes for patient
	# we can't require subject_id on create
	validates_presence_of   :subject, :on => :update
	validates_uniqueness_of :subject_id, :allow_nil => true

end

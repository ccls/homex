class ChildId < ActiveRecord::Base
	belongs_to :subject

	# because subject accepts_nested_attributes for child_id
	# we can't require subject_id on create
	validates_presence_of   :subject_id, :on => :update
	validates_uniqueness_of :subject_id, :allow_nil => true
	validate                :valid_subject_id

	validates_presence_of :childid

protected

	def valid_subject_id
		#	valid subject on update
		#	validate doesn't seem to take :on => :update
		if !self.new_record? && !Subject.exists?(subject_id)
			errors.add(:subject_id, "is invalid") 
		end
	end

end

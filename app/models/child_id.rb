class ChildId < ActiveRecord::Base
	belongs_to :subject

	# because subject accepts_nested_attributes for child_id
	# we can't require subject_id on create
	validates_presence_of   :subject, :on => :update
	validates_uniqueness_of :subject_id, :allow_nil => true

	validates_presence_of :childid

end

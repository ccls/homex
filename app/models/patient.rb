class Patient < ActiveRecord::Base
	belongs_to :subject

	# because subject accepts_nested_attributes for pii 
	# we can't require subject_id on create
	validates_presence_of :subject_id, :on => :update
	validates_uniqueness_of :subject_id, :on => :update

end

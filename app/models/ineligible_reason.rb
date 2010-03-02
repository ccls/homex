class IneligibleReason < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :project_subjects
	validates_length_of :description, :minimum => 4
	validates_uniqueness_of :description
end

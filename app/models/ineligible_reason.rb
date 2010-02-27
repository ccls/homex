class IneligibleReason < ActiveRecord::Base
	has_many :project_subjects
	validates_length_of :description, :minimum => 4
end

class SubjectType < ActiveRecord::Base
#	has_many :subjects
	validates_length_of :description, :minimum => 4
end

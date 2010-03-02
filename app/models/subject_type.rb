class SubjectType < ActiveRecord::Base
	acts_as_list
	has_many :subjects
	validates_length_of :description, :minimum => 4
	validates_uniqueness_of :description

	named_scope :list, :order => :position
end

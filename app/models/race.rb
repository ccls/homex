class Race < ActiveRecord::Base
	acts_as_list
	has_many :subjects
	validates_uniqueness_of :name
	validates_length_of :name, :minimum => 4
	named_scope :list, :order => :position
end

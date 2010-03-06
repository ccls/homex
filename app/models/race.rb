class Race < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :subjects

	validates_uniqueness_of :name
	validates_length_of :name, :minimum => 4
end

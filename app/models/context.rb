class Context < ActiveRecord::Base
	acts_as_list
	has_many :units
	has_many :people
	validates_length_of :description, :minimum => 4
	validates_uniqueness_of :description
end

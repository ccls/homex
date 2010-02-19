class Context < ActiveRecord::Base
	has_many :units
#	has_many :people
	validates_length_of :description, :minimum => 4
end

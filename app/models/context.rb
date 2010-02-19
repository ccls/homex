class Context < ActiveRecord::Base
	has_many :units
	has_many :interviewers #	was people on uml diagram
	validates_length_of :description, :minimum => 4
end

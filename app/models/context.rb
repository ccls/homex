class Context < ActiveRecord::Base
	has_many :units
	validates_length_of :description, :minimum => 4
end

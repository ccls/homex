class Race < ActiveRecord::Base
	has_many :subjects
	validates_length_of :name, :minimum => 4
end

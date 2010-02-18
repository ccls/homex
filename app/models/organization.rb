class Organization < ActiveRecord::Base
	validates_length_of :name, :minimum => 4
	validates_uniqueness_of :name
end

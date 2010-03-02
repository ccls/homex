class SampleType < ActiveRecord::Base
	acts_as_list
	has_many :sample_subtypes
	validates_length_of :description, :minimum => 4
	validates_uniqueness_of :description
end

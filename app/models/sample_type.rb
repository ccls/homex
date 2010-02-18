class SampleType < ActiveRecord::Base
	has_many :sample_subtypes
	validates_length_of :description, :minimum => 4
end

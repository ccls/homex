class AliquotSampleFormat < ActiveRecord::Base
#	has_many :aliquots
	has_many :samples
	validates_length_of :description, :minimum => 4
end

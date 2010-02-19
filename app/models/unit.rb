class Unit < ActiveRecord::Base
	belongs_to :context
#	has_many :aliquots
#	has_many :samples
	validates_length_of :description, :minimum => 4
end

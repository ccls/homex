class Organization < ActiveRecord::Base
#	has_many :aliquots
#	has_many :samples
#	has_many :transfers_to
#	has_many :transfers_from

	validates_length_of :name, :minimum => 4
	validates_uniqueness_of :name
end

# == has_many
# * #Aliquot
# * #Sample
class AliquotSampleFormat < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :aliquots
	has_many :samples

	validates_length_of :description, :minimum => 4
	validates_uniqueness_of :description
end

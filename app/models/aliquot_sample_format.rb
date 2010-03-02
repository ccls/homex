class AliquotSampleFormat < ActiveRecord::Base
	acts_as_list
	has_many :aliquots
	has_many :samples
	validates_length_of :description, :minimum => 4
	validates_uniqueness_of :description
	named_scope :list, :order => :position
end

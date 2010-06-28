#	==	requires
#	*	description ( unique and > 3 chars )
class Unit < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	belongs_to :context
	has_many :aliquots
	has_many :samples

	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description
end

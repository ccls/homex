#	==	requires
#	*	name ( unique and > 3 chars )
class Race < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :subjects

	validates_uniqueness_of :name
	validates_length_of     :name, :minimum => 4

	def to_s
		name
	end

end

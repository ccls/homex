#	==	requires
#	*	description ( unique and > 3 chars )
class SubjectType < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :subjects

	validates_presence_of :description
#	validates_length_of :description, :minimum => 4
	validates_uniqueness_of :description

	def to_s
		description
	end

	def name
		description
	end

end

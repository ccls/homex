#	==	requires
#	*	description ( unique and > 3 chars )
class SubjectType < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :subjects

	validates_presence_of   :description
#	validates_length_of     :description, :is => 1
	validates_uniqueness_of :description
#	validates_format_of     :description, :with => /\w/

	def to_s
		description
	end

	def name
		description
	end

end

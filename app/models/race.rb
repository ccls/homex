#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
class Race < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :subjects

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

	def to_s
		description
	end

	def name
		description
	end

	class NotFound < StandardError; end

	def self.[](code)
		find_by_code(code) || raise(NotFound)
	end

end

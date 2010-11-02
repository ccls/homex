# don't know exactly
class InterviewMethod < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :interviews
	has_many :instruments

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

	validates_length_of :code, :description,
		:maximum => 250, :allow_blank => true

	#	Returns description
	def to_s
		description
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

end

class SubjectRelationship < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

#	has_many :subjects

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

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

	#	Returns boolean of comparison
	#	true only if code == 'other'
	def is_other?
		code == 'other'
	end

end

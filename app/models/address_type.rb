#	The type of address (home,work,residence,pobox,etc.)
class AddressType < ActiveRecord::Base
	acts_as_list
	has_many :addresses
	validates_presence_of   :code
	validates_length_of     :code, :minimum => 4
	validates_uniqueness_of :code
	validates_length_of :code, :description,
		:maximum => 250, :allow_blank => true

	#	Returns the code
	def to_s
		self.code
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

end

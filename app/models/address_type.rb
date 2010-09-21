#	The type of address (home,work,residence,pobox,etc.)
class AddressType < ActiveRecord::Base
	acts_as_list
	has_many :addresses
	validates_presence_of   :code
	validates_length_of     :code, :minimum => 4
	validates_uniqueness_of :code

	def to_s
		self.code
	end

	def self.[](code)
		find_by_code(code)
	end

end

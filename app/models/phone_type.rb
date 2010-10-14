# The type of phone number (home,work,mobile,etc.)
class PhoneType < ActiveRecord::Base
	has_many :phone_numbers
	acts_as_list
	validates_presence_of   :code
	validates_length_of     :code, :minimum => 4
	validates_uniqueness_of :code

	#	Returns code
	def to_s
		code
	end

end

class PhoneType < ActiveRecord::Base
	has_many :phone_numbers
	acts_as_list
	validates_presence_of   :code
	validates_length_of     :code, :minimum => 4
	validates_uniqueness_of :code

	def to_s
		self.code
	end

end

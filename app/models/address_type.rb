class AddressType < ActiveRecord::Base
	acts_as_list
	has_many :addresses
	validates_presence_of   :code
	validates_length_of     :code, :minimum => 4
	validates_uniqueness_of :code
end

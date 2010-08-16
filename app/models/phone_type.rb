class PhoneType < ActiveRecord::Base
	acts_as_list
	validates_presence_of :code
	validates_uniqueness_of :code
end

class Hospital < ActiveRecord::Base
	acts_as_list
	belongs_to :organization
end

class Role < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position
	has_and_belongs_to_many :users
end

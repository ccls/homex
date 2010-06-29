class DataSource < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position
	has_many :addresses
end

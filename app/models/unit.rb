class Unit < ActiveRecord::Base
	belongs_to :context
	validates_length_of :description, :minimum => 4
end

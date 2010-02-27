class RefusalReason < ActiveRecord::Base
	validates_length_of :description, :minimum => 4
end

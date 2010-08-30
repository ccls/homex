# don't know exactly
class Person < ActiveRecord::Base
#	belongs_to :context
	has_many :interviews, :foreign_key => 'interviewer_id'
end

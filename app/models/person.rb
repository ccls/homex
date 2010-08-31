# don't know exactly
class Person < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

#	belongs_to :context
	has_many :interviews, :foreign_key => 'interviewer_id'

	validates_presence_of :last_name
end

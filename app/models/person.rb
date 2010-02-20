class Person < ActiveRecord::Base
	belongs_to :context
	has_many :interview_events, :foreign_key => 'interviewer_id'
end

class Address < ActiveRecord::Base
	has_many :interview_events
	has_one :residence
	belongs_to :subject
	belongs_to :address_type
end

class OperationalEvent < ActiveRecord::Base
#	belongs_to :subject
	belongs_to :operational_event_type
end

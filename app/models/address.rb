class Address < ActiveRecord::Base
	has_many :interview_events
	has_many :residences, :dependent => :destroy
#	has_many :subjects, :through => :residences
end

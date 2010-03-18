class Address < ActiveRecord::Base
	has_many :interview_events
	has_many :residences	#	was addresses_subjects
#	has_many :subjects, :through => :residences
end

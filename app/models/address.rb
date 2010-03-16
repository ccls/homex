# == has_many:
# * #InterviewEvent
# * #Residence
class Address < ActiveRecord::Base
	has_many :interview_events
	has_many :residences	#	was addresses_subjects
#	has_many :subjects, :through => :addresses_subjects
end

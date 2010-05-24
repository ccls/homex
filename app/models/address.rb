class Address < ActiveRecord::Base

	has_many :interview_events

	#	Residences is a rich join.  
	#	Destroy to not destroy?
	has_many :residences, :dependent => :destroy

#	has_many :subjects, :through => :residences
end

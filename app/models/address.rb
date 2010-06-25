class Address < ActiveRecord::Base

	has_many :interview_events

	#	Residences is a rich join.  
	#	Destroy to not destroy?
	has_many :residences

#	has_many :subjects, :through => :residences

	belongs_to :address_type
end

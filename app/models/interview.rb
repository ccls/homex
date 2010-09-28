#	==	requires
#	*	address_id
#	*	interviewer_id
#	*	identifier_id
class Interview < ActiveRecord::Base
	belongs_to :identifier
	has_one :subject, :through => :identifier
#	I think that these are pushing it a bit far.
#		(they do work though)
#	has_one :homex_outcome, :through => :subject
#	has_one :interview_outcome, :through => :homex_outcome
	belongs_to :address
	belongs_to :interviewer, :class_name => 'Person'
	belongs_to :instrument_version
	belongs_to :interview_method
	belongs_to :language

#	has_many :operational_event_types

#	validates_presence_of :identifier

#	stringify_date :began_on, :ended_on, 
#		:format => '%m/%d/%Y'

	def respondent_full_name
		"#{respondent_first_name} #{respondent_last_name}"
	end

end

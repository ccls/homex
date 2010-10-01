#	==	requires
#	*	address_id
#	*	interviewer_id
#	*	identifier_id
class Interview < ActiveRecord::Base
	belongs_to :identifier
#	Occassionally getting .... for when 
#		Instrument Version ... Instrument ... Project was unknown?
#TypeError (can't dup NilClass):
#  app/controllers/interviews_controller.rb:52:in `valid_id_required'
#	has_one :subject, :through => :identifier
#		changed from has_one to delegate to see if better
	delegate :subject, :to => :identifier

#	I think that these are pushing it a bit far.
#		(they do work though)
#	has_one :homex_outcome, :through => :subject
#	has_one :interview_outcome, :through => :homex_outcome
	belongs_to :address
	belongs_to :interviewer, :class_name => 'Person'
	belongs_to :instrument_version
	belongs_to :interview_method
	belongs_to :language
	belongs_to :subject_relationship


	validates_presence_of :subject_relationship_other,
		:if => :subject_relationship_is_other?
	validates_absence_of :subject_relationship_other,
		:message => "not allowed",
		:unless => :subject_relationship_is_other?

	def respondent_full_name
		"#{respondent_first_name} #{respondent_last_name}"
	end

protected

	def subject_relationship_is_other?
		subject_relationship.try(:is_other?)
	end

end

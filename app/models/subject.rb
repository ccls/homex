#	==	requires
#	*	subject_type_id
#	*	race_id
class Subject < ActiveRecord::Base

#	belongs_to :hispanicity
	belongs_to :race
	belongs_to :subject_type
	belongs_to :vital_status

	has_and_belongs_to_many :analyses

	has_many :addressings
	has_many :addresses, :through => :addressings
	has_many :enrollments
#	has_many :home_exposure_events
#	has_many :hospitals
#	has_many :operational_events
	has_many :phone_numbers
	has_many :response_sets
	has_many :samples
	has_many :survey_invitations

	has_one :identifier
	has_one :home_exposure_response
	has_one :homex_outcome
	has_one :patient
	has_one :pii

	validates_presence_of :subject_type, :race,
		:subject_type_id, :race_id
#	validates_inclusion_of :sex, :in => %w( male female ),
#		:message => "must be male or female"

	validates_complete_date_for :reference_date,
		:allow_nil => true

	validates_inclusion_of :do_not_contact, :in => [ true, false ]

	delegate :full_name, :email,
		:last_name, :first_name, :dob, #:dob_string,
		:fathers_name, :mothers_name,
		:to => :pii, :allow_nil => true

	delegate :childid, :ssn, :patid, :orderno, :studyid,
		:to => :identifier, :allow_nil => true

	delegate :interview_outcome, :interview_outcome_on,
		:sample_outcome,    :sample_outcome_on,
		:to => :homex_outcome, :allow_nil => true

	#	can lead to multiple piis in db for subject
	#	if not done correctly
	#	s.update_attributes({"pii_attributes" => { "ssn" => "123456789", 'state_id_no' => 'x'}})
	#	s.update_attributes({"pii_attributes" => { "ssn" => "987654321", 'state_id_no' => 'a'}})
	#	Pii.find(:all, :conditions => {:subject_id => s.id }).count 
	#	=> 2
	#	without the :id attribute, it will create, but NOT destroy
	#	s.reload.pii  will return the first one (sorts by id)
	#	s.pii.destroy will destroy the last one !?!?!?
	#	Make all these require a unique subject_id
	accepts_nested_attributes_for :pii
	accepts_nested_attributes_for :homex_outcome

#	Where do I use patient_attributes?
#	accepts_nested_attributes_for :patient
#	Where do I use identifier_attributes?
#	accepts_nested_attributes_for :identifier
##	accepts_nested_attributes_for :dust_kit

	class NotTwoResponseSets < StandardError; end

	def residence_addresses_count
		addresses.count(
			:joins => :address_type,
			:conditions => "address_types.code = 'residence'"
		)
	end

	def is_case?
		subject_type.try(:code) == 'Case'
	end

	def hx_enrollment
		enrollments.find(:first,
			:conditions => "projects.code = 'HomeExposures'",
			:joins => :project)
	end

	def hx_interview
		identifier.interviews.find(:first,
			:conditions => "projects.code = 'HomeExposures'",
			:joins => [:instrument_version => [:instrument => :project]]
		) unless identifier.nil?
	end

	def response_sets_the_same?
		if response_sets.length == 2
			#	response_sets.inject(:is_the_same_as?) was nice
			#	but using inject is ruby >= 1.8.7
			return response_sets[0].is_the_same_as?(response_sets[1])
		else
			raise NotTwoResponseSets
		end
	end

	def response_set_diffs
		if response_sets.length == 2
			#	response_sets.inject(:diff) was nice
			#	but using inject is ruby >= 1.8.7
			return response_sets[0].diff(response_sets[1])
		else
			raise NotTwoResponseSets
		end
	end

	def recreate_survey_invitation(survey)
		SurveyInvitation.destroy_all( 
			:subject_id => self.id,
			:survey_id  => survey.id 
		)
		self.survey_invitations.create(
			:survey_id => survey.id
		)
	end

	def is_eligible_for_invitation?
		!self.email.blank?
	end

	def her_invitation
		if survey = Survey.find_by_access_code('home_exposure_survey')
			self.survey_invitations.find_by_survey_id(survey.id)
		end
	end

#	def dust_kit_status
#		dust_kit.try(:status) || 'None'
#	end

	def self.for_hx(params={})
		Subject.search(params.deep_merge(
			:projects=>{hx_id=>{}}
		))
	end

	def self.for_hx_interview(params={})
		Subject.search(params.deep_merge(
			:projects=>{hx_id=>{:chosen=>true}}
		))
#		@subjects = SubjectSearch.new(params).subjects
#	eventually
#		@subjects = hx.subjects.search(params.merge(
#			:interview_outcome => 'incomplete'
#		))
	end

	def self.for_hx_followup(params={})
		options = params.deep_merge(
			:projects=>{hx_id=>{}}
		)
		options.merge!(
			:sample_outcome => 'complete',
			:interview_outcome => 'complete'
		)
		Subject.search(options)
	end

	def self.for_hx_sample(params={})
		options = params.deep_merge(
			:projects=>{hx_id=>{}}
		)
		options.merge!(
#			:sample_outcome => 'incomplete',
			:interview_outcome => 'complete'
		)
		Subject.search(options)
	end

	def self.search(params={})
		SubjectSearch.new(params).subjects
	end

protected

	def self.hx_id
		#	added try and || for usage on empty db
		Project['HomeExposures'].try(:id)||0
	end

end

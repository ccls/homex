#	==	requires
#	*	subject_type_id
#	*	race_id
class Subject < ActiveRecord::Base
	belongs_to :subject_type
	belongs_to :race
	has_many :samples
	has_many :project_subjects
	has_many :operational_events
	has_many :residences
	has_many :interview_events
	has_many :study_event_eligibilities
	has_many :response_sets
	has_one :home_exposure_response
	has_one :pii,      :dependent => :destroy
	has_one :patient,  :dependent => :destroy
	has_one :child_id, :dependent => :destroy
	has_many :survey_invitations

	validates_presence_of :subject_type_id
	validate :valid_subject_type
	validates_presence_of :race_id
	validate :valid_race

	delegate :ssn,       :to => :pii, :allow_nil => true
	delegate :full_name, :to => :pii, :allow_nil => true
	delegate :email,     :to => :pii, :allow_nil => true
	delegate :childid,   :to => :child_id, :allow_nil => true

	#	can lead to multiple piis in db for subject
	#	if not done correctly
	#	s.update_attributes({"pii_attributes" => { "ssn" => "123456789", 'state_id_no' => 'x'}})
	#	s.update_attributes({"pii_attributes" => { "ssn" => "987654321", 'state_id_no' => 'a'}})
	#	Pii.find(:all, :conditions => {:subject_id => s.id }).count 
	#	=> 2
	#	without the :id attribute, it will create, but NOT destroy
	#	s.reload.pii  will return the first one (sorts by id)
	#	s.pii.destroy will destroy the last one !?!?!?
	accepts_nested_attributes_for :pii
	accepts_nested_attributes_for :patient
	accepts_nested_attributes_for :child_id

	class NotTwoResponseSets < StandardError; end

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

protected

	def valid_subject_type
		errors.add(:subject_type_id, "is invalid") unless SubjectType.exists?(subject_type_id)
	end

	def valid_race
		errors.add(:race_id, "is invalid") unless Race.exists?(race_id)	
	end

end

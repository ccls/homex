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
	has_one :pii
	has_one :home_exposure_response

	validates_presence_of :subject_type_id
	validates_presence_of :race_id

	delegate :ssn, :to => :pii, :allow_nil => true
	delegate :full_name, :to => :pii, :allow_nil => true

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

	class NotTwoResponseSets < StandardError; end

	def response_sets_the_same?
		if response_sets.length == 2
			return response_sets[0].is_the_same_as?(response_sets[1])
		else
			raise NotTwoResponseSets
		end
	end

	def response_set_diffs
		if response_sets.length == 2
			return response_sets[0].diff(response_sets[1])
		else
			raise NotTwoResponseSets
		end
	end

end

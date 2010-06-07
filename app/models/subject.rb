#	==	requires
#	*	subject_type_id
#	*	race_id
class Subject < ActiveRecord::Base
	belongs_to :subject_type
	belongs_to :race
	has_many :samples, :dependent => :destroy
	has_many :project_subjects, :dependent => :destroy
	has_many :operational_events, :dependent => :destroy
	has_many :residences, :dependent => :destroy
	has_many :interview_events, :dependent => :destroy
	has_many :study_event_eligibilities, :dependent => :destroy
	has_many :response_sets, :dependent => :destroy
	has_one :home_exposure_response, :dependent => :destroy
	has_one :pii,      :dependent => :destroy
	has_one :patient,  :dependent => :destroy
	has_one :child_id, :dependent => :destroy
	has_one :dust_kit, :dependent => :destroy
	has_many :survey_invitations, :dependent => :destroy

	validates_presence_of :subject_type, :race
	validates_presence_of   :subjectid
	validates_uniqueness_of :subjectid

	delegate :ssn,       :to => :pii, :allow_nil => true
	delegate :full_name, :to => :pii, :allow_nil => true
	delegate :email,     :to => :pii, :allow_nil => true
	delegate :patid,     :to => :pii, :allow_nil => true
	delegate :orderno,   :to => :pii, :allow_nil => true
	delegate :last_name, :to => :pii, :allow_nil => true
	delegate :first_name,:to => :pii, :allow_nil => true
	delegate :dob,       :to => :pii, :allow_nil => true
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
	accepts_nested_attributes_for :dust_kit

	class NotTwoResponseSets < StandardError; end

	def studyid
		"#{patid}-#{orderno}"
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

	def dust_kit_status
		dust_kit.try(:status) || 'None'
	end

	def self.search(params={})
		conditions = { }
		joins = []
		#	mixing Strings and Symbols in the joins array caused
		#		raise ConfigurationError, 
		#			"Association named '#{ associations } ' was not found; 
		#				perhaps you misspelled it?"
		#	so I created a separate scope to handle the strings.
		#	The rails documentation which states that it can be 
		#		"an array containing a mixture of both 
		#			strings and named associations"
		#	is incorrect.
		sql_scope = { :joins => [] }
		sql_conditions = []
		sql_values = []
		if params[:type] && !params[:type].blank?
			joins.push(:subject_type)
			conditions['subject_types.description'] = params[:type]
		end
		if params[:types] && !params[:types].blank?
			joins.push(:subject_type)
			conditions['subject_types.description'] = params[:types]
		end
		if params[:race] && !params[:race].blank?
			joins.push(:race)
			conditions['races.name'] = params[:race]
		end
		if params[:races] && !params[:races].blank?
			joins.push(:race)
			conditions['races.name'] = params[:races]
		end
		if params[:dust_kit] && !params[:dust_kit].blank?
			if params[:dust_kit] == 'shipped'
				#	Shipped to subject
				joins.push(:dust_kit => [:kit_package])
			elsif params[:dust_kit] == 'delivered'
				#	Delivered to subject
				joins.push(:dust_kit => [:kit_package])
				conditions['packages.status'] = 'Delivered'
			elsif params[:dust_kit] == 'returned'
				#	Subject has returned
				joins.push(:dust_kit => [:dust_package])
				conditions['packages.status'] = 'Transit'
			elsif params[:dust_kit] == 'received'
				#	WE have received it
				joins.push(:dust_kit => [:dust_package])
				conditions['packages.status'] = 'Delivered'
			elsif params[:dust_kit] == 'none'
				sql_scope[:joins].push(
					'LEFT JOIN dust_kits ON dust_kits.subject_id = subjects.id')
				conditions['dust_kits.id'] = nil
			end
		end
		if params[:study_events] && !params[:study_events].blank?
#
#	more than one study_event will always return nothing (for now)
#	would be nice if I could do a "join as" or something to give the
#	joined table an alias.  Should look into this. Would move the
#	join inside this loop.
#	This should now work with the added aliases
#
			params[:study_events].keys.each do |id|
				sql_scope[:joins].push(
					"JOIN project_subjects se_#{id} ON subjects.id "<<
						"= se_#{id}.subject_id AND se_#{id}.study_event_id = #{id}" 
				)
				params[:study_events][id].keys.each do |attr|
					val = [params[:study_events][id][attr]].flatten
					case attr.to_s.downcase
						when 'eligible'
							if val.true_xor_false?
								conditions["se_#{id}.is_eligible"] = val.to_boolean
							end
						when 'chosen'
							if val.true_xor_false?
								conditions["se_#{id}.is_chosen"] = val.to_boolean
							end
						when 'consented'
							if val.true_xor_false?
								conditions["se_#{id}.consented"] = val.to_boolean
							end
						when 'terminated'
							if val.true_xor_false?
								conditions["se_#{id}.subject_terminated_participation"] = val.to_boolean
							end
						when 'closed'
							if val.true_xor_false?
								conditions["se_#{id}.is_closed"] = val.to_boolean
							end
						when 'completed'
							if val.true_xor_false?
								if val.true?
									sql_conditions.push(
											"se_#{id}.completed_on IS NOT NULL")
								else
									conditions["se_#{id}.completed_on"] = nil
								end
							end
#=> ProjectSubject(id: integer, position: integer, subject_id: integer, study_event_id: integer, ineligible_reason_id: integer, refusal_reason_id: integer, reason_not_chosen: string, recruitment_priority: string, completed_on: date, consented_on: date, other_refusal_reason: string, subject_terminated_reason: string, reason_closed: string, created_at: datetime, updated_at: datetime)
					end
				end if params[:study_events][id].is_a?(Hash)

			end
		end

		sql_scope[:conditions] = [sql_conditions.join(" && "), 
			sql_values].flatten

		with_scope( :find => sql_scope ) do
			paginate(
				:readonly => false,
				:page => params[:page], 
				:per_page => params[:per_page]||25,
				:joins => joins,
				:conditions => conditions,
				:include => [:race,:subject_type,:child_id,
					{:dust_kit => [:kit_package,:dust_package]}]
			)
		end
	end

end

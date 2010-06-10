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

	def birthdate
#		bd = ( respond_to?(:dob) ) ? dob : pii.dob
#		#	for some reason this can be a String and not Date???
#		#	if it is acquired through sql joins as a virtual column
#		if bd
#			if bd.is_a?(String)
#				Date.parse(bd).to_s(:dob)
#			else
#				bd.try(:to_s,:dob)
#			end
#		else
#			nil
#		end
		dob.try(:to_s,:dob)
	end

	def studyid
#		if respond_to?(:patid) && respond_to?(:orderno)
			"#{patid}-#{orderno}"
#		else
#			"#{pii.patid}-#{pii.orderno}"
#		end
	end

	def outcome_date
		"TEST"
	end

	def outcome
		"TEST"
	end

	def priority
#		if respond_to?('project_subjects.recruitment_priority')
#			project_subjects.recruitment_priority
#		elsif respond_to?('recruitment_priority')
#			recruitment_priority
#		else
			'TEST'
#		end
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
		order = nil
		conditions = { }
		joins = []
		includes = [:pii,:child_id]
		sql_scope = { :joins => [] }
#			'LEFT OUTER JOIN piis ON subjects.id = piis.subject_id',
#			'LEFT OUTER JOIN child_ids ON subjects.id = child_ids.subject_id'
#		]}
		sql_conditions = []
		sql_values = []
#		selects = [Subject.default_scoping.first[:find][:select]]
#		selects = ['subjects.*']

		if params[:types] && !params[:types].blank?
			joins.push(:subject_type)
			conditions['subject_types.description'] = params[:types]
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
#	ActiveRecord::ConfigurationError: Association named 'LEFT JOIN dust_kits dk1 ON dust_kits.subject_id = subjects.id' was not found; perhaps you misspelled it?
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
#				#	No idea what'll happen with multiple se's here.
#				selects.push("se_#{id}.recruitment_priority as priority")
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
					end
				end if params[:study_events][id].is_a?(Hash)
			end
		end

		if params[:order]
			order = case params[:order].downcase
				when 'childid'    then 'child_ids.childid'
				when 'last_name'  then 'piis.last_name'
				when 'first_name' then 'piis.first_name'
				when 'dob'        then 'piis.dob'
				when 'studyid'    then 'piis.patid'
				when 'priority'   then 'recruitment_priority'
#				when 'priority'   then 'project_subjects.recruitment_priority'
#				when 'priority'   then 'priority'
#					selects.push('recruitment_priority as priority')
#					'recruitment_priority'
				else nil
			end
			if order && params[:dir]
				dir = case params[:dir].downcase
					when 'desc' then 'desc'
					else 'asc'
				end
				order = [order,dir].join(' ')
			end
		end

		if params[:q] && !params[:q].blank?
			c = []
			v = {}
			params[:q].split(/\s+/).each_with_index do |q,i|
				c.push("piis.first_name LIKE :q#{i}")
				c.push("piis.last_name LIKE :q#{i}")
				v["q#{i}".to_sym] = "%#{q}%"
			end
			sql_conditions.push("( #{c.join(' OR ')} )")
			sql_values.push(v)
		end

		sql_scope[:conditions] = [sql_conditions.join(" AND "), 
			sql_values].flatten

		find_options = {
#			:select => selects.join(','),
			:order => order,
			:joins => joins,
			:include => includes,
			:conditions => conditions
		}

		with_scope( :find => sql_scope ) do
			if !params[:paginate].nil? && params[:paginate].false?
				find(:all, find_options)
			else
				paginate(find_options.merge({
					:page => params[:page], 
					:per_page => params[:per_page]||25
				}))
			end
		end
	end

#	default_scope :select => "subjects.*, child_ids.childid, piis.orderno, piis.patid, piis.first_name, piis.last_name, piis.dob",
#		:joins => [
#			'LEFT OUTER JOIN piis ON subjects.id = piis.subject_id',
#			'LEFT OUTER JOIN child_ids ON subjects.id = child_ids.subject_id'
#		]

#
#	Tried all these special selects and virtual columns as
#	it was supposed to speed things up, but hasn't made
#	much difference.  Created a default_scope and removed
#	some delegated stuff.  Probably put it back.  The includes
#	were causing some grief, but may try again.
#

end

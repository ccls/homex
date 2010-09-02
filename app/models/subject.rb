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
	has_many :home_exposure_events
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
		:subject_type_id, :race_id,
		:subjectid
	validates_uniqueness_of :subjectid
#	validates_inclusion_of :sex, :in => %w( male female ),
#		:message => "must be male or female"

	delegate :full_name, :email,
		:last_name, :first_name, :dob, :dob_string,
		:fathers_name, :mothers_name,
		:to => :pii, :allow_nil => true

	delegate :childid, :ssn, :patid, :orderno, :studyid,
		:to => :identifier, :allow_nil => true

#	Can't do this as WE NEED to set this.
#	Would be nice if there was an update_attributes filter or something
#	attr_protected :subjectid

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

#	Where do I use patient_attributes?
#	accepts_nested_attributes_for :patient
#	Where do I use identifier_attributes?
#	accepts_nested_attributes_for :identifier
##	accepts_nested_attributes_for :dust_kit

	class NotTwoResponseSets < StandardError; end

	before_validation :pad_zeros_to_subjectid

#		def outcome_date
#			"TEST"
#		end
#	
#		def outcome
#			"TEST"
#		end
#	
#		def priority
#	#		if respond_to?('enrollments.recruitment_priority')
#	#			enrollments.recruitment_priority
#	#		elsif respond_to?('recruitment_priority')
#	#			recruitment_priority
#	#		else
#				'TEST'
#	#		end
#		end

	def is_case?
		subject_type.try(:code) == 'Case'
	end

	def hx_enrollment
		enrollments.find(:first,
			:conditions => "projects.code = 'HomeExposures'",
			:joins => :project)
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

	def self.search(params={})
		order = nil
		conditions = { }
		joins = []
		includes = [:pii,:identifier]
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
			conditions['races.description'] = params[:races]
		end

		if params[:vital_statuses] && !params[:vital_statuses].blank?
			joins.push(:vital_status)
			conditions['vital_statuses.code'] = params[:vital_statuses]
		end

#		if params[:dust_kit] && !params[:dust_kit].blank?
#			if params[:dust_kit] == 'shipped'
#				#	Shipped to subject
#				joins.push(:dust_kit => [:kit_package])
#			elsif params[:dust_kit] == 'delivered'
#				#	Delivered to subject
#				joins.push(:dust_kit => [:kit_package])
#				conditions['packages.status'] = 'Delivered'
#			elsif params[:dust_kit] == 'returned'
#				#	Subject has returned
#				joins.push(:dust_kit => [:dust_package])
#				conditions['packages.status'] = 'Transit'
#			elsif params[:dust_kit] == 'received'
#				#	WE have received it
#				joins.push(:dust_kit => [:dust_package])
#				conditions['packages.status'] = 'Delivered'
#			elsif params[:dust_kit] == 'none'
##	ActiveRecord::ConfigurationError: Association named 'LEFT JOIN dust_kits dk1 ON dust_kits.subject_id = subjects.id' was not found; perhaps you misspelled it?
#				sql_scope[:joins].push(
#					'LEFT JOIN dust_kits ON dust_kits.subject_id = subjects.id')
#				conditions['dust_kits.id'] = nil
#			end
#		end

		if params[:projects] && !params[:projects].blank?
#
#	more than one project will always return nothing (for now)
#	would be nice if I could do a "join as" or something to give the
#	joined table an alias.  Should look into this. Would move the
#	join inside this loop.
#	This should now work with the added aliases
#

			params[:projects].keys.each do |id|
				sql_scope[:joins].push(
					"JOIN enrollments se_#{id} ON subjects.id "<<
						"= se_#{id}.subject_id AND se_#{id}.project_id = #{id}" 
				)
#				#	No idea what'll happen with multiple se's here.
#				selects.push("se_#{id}.recruitment_priority as priority")
				params[:projects][id].keys.each do |attr|
					val = [params[:projects][id][attr]].flatten
					case attr.to_s.downcase
						when 'eligible'
							if val.true_xor_false?
								conditions["se_#{id}.is_eligible"] = val.to_boolean
							end
						when 'candidate'
							if val.true_xor_false?
								conditions["se_#{id}.is_candidate"] = val.to_boolean
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
								conditions["se_#{id}.terminated_participation"] = val.to_boolean
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
				end if params[:projects][id].is_a?(Hash)
			end
		end

		if params[:order]
			order = case params[:order].downcase
				when 'childid'    then 'identifiers.childid'
				when 'last_name'  then 'piis.last_name'
				when 'first_name' then 'piis.first_name'
				when 'dob'        then 'piis.dob'
				when 'studyid'    then 'identifiers.patid'
				when 'priority'   then 'recruitment_priority'
#				when 'priority'   then 'enrollments.recruitment_priority'
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
			params[:q].to_s.split(/\s+/).each_with_index do |q,i|
				c.push("piis.first_name LIKE :q#{i}")
				c.push("piis.last_name LIKE :q#{i}")
				c.push("identifiers.patid LIKE :q#{i}")
				c.push("identifiers.childid LIKE :q#{i}")
				v["q#{i}".to_sym] = "%#{q}%"
			end
			sql_conditions.push("( #{c.join(' OR ')} )")
			sql_values.push(v)
		end

		#	Because this table can be used to join twice,
		#	we'll do it once here to avoid any mysql complaints like ..
		#	Mysql::Error: Not unique table/alias: 'homex_outcomes':
		if( params[:sample_outcome] && !params[:sample_outcome].blank? ) ||
		  ( params[:interview_outcome] && !params[:interview_outcome].blank? )
			sql_scope[:joins].push(
				"LEFT JOIN homex_outcomes ON " <<
					"homex_outcomes.subject_id = subjects.id " )

			if params[:sample_outcome] && !params[:sample_outcome].blank?
				sql_scope[:joins].push(
					"LEFT JOIN sample_outcomes ON " <<
						"sample_outcomes.id = homex_outcomes.sample_outcome_id"
				)
				if params[:sample_outcome] =~ /^Complete$/i
					conditions['sample_outcomes.code'] = params[:sample_outcome]
				else
					sql_conditions.push( "(sample_outcomes.code != 'Complete' " <<
						"OR sample_outcomes.code IS NULL)")
				end
			end

			if params[:interview_outcome] && !params[:interview_outcome].blank?
				sql_scope[:joins].push(
					"LEFT JOIN interview_outcomes ON " <<
						"interview_outcomes.id = homex_outcomes.interview_outcome_id"
				)
				if params[:interview_outcome] =~ /^Complete$/i
					conditions['interview_outcomes.code'] = params[:interview_outcome]
				else
					sql_conditions.push( "(interview_outcomes.code != 'Complete'" <<
						"OR interview_outcomes.code IS NULL)")
				end
			end
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

protected

	def pad_zeros_to_subjectid
		#>> sprintf("%06d","0001234")
		#=> "000668"
		#>> sprintf("%06d","0001239")
		#ArgumentError: invalid value for Integer: "0001239"
		#	from (irb):22:in `sprintf'
		#	from (irb):22
		#>> sprintf("%06d","0001238")
		#ArgumentError: invalid value for Integer: "0001238"
		#	from (irb):23:in `sprintf'
		#	from (irb):23
		#>> sprintf("%06d","0001280")
		#ArgumentError: invalid value for Integer: "0001280"
		#	from (irb):24:in `sprintf'
		#	from (irb):24
		#
		#	CANNOT have leading 0's and include and 8 or 9 as it thinks its octal
		#	so convert back to Integer first
		subjectid.try(:gsub!,/\D/,'')
		self.subjectid = sprintf("%06d",subjectid.to_i) unless subjectid.blank?
	end

end

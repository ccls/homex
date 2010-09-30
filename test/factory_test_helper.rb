module FactoryTestHelper

	def full_response(options={})
		survey = Factory(:survey)
		survey_section = Factory(:survey_section, :survey => survey)
		question = Factory(:question, { 
			:survey_section => survey_section }.merge(options[:question]||{}))
		answer = Factory(:answer, { :question => question,
			:response_class => "answer" }.merge(options[:answer]||{}))
		response_set = Factory(:response_set, {
			:survey => survey}.merge(options[:response_set]||{}))
		response = Factory(:response, {
			:response_set => response_set,
			:question => question, 
			:answer => answer}.merge(options[:response]||{})
		)
	end

	def q_and_a_for(survey_section, options={})
		question = Factory(:question, { 
			:survey_section => survey_section 
		}.merge(options[:question]||{}))
		Factory(:answer, { 
			:question => question,
			:response_class => "answer" 
		}.merge(options[:answer]||{}))
		question
	end

	def full_response_set(options={})
		survey = if options[:survey].is_a?(Survey)
			#	A survey and its q and a already exist.
			options[:survey]
		else
			#	assuming that its a hash
			s = Factory(:survey, options[:survey]||{} )
			survey_section = Factory(:survey_section, :survey => s )
			q_and_a_for(survey_section,{
				:question => {
					:data_export_identifier => 'construction_in_home'},
				:answer   => {:data_export_identifier => 2 }
			})
			q_and_a_for(survey_section,{
				:question => {
					:data_export_identifier => 'other_home_remodelling'},
				:answer   => {:data_export_identifier => 1 }
			})
			q_and_a_for(survey_section, { 
				:question => {
					:data_export_identifier => 'type_other_home_remodelling'},
				:answer => { :response_class => "string" }
			})
			q_and_a_for(survey_section, { 
				:question => {:data_export_identifier => 'year_home_built'},
				:answer => { :response_class => "integer" }
			})
			s
		end
		response_set = Factory(:response_set, {
			:survey => survey}.merge(options[:response_set]||{}))

		survey.sections.each do |section|
			section.questions.each do |question|
				response = Factory.build(:response, {
					:response_set => response_set,
					:question => question, 
					:answer => question.answers.first
				}.merge(options[:response]||{}))
				case response.answer.response_class
					when 'string'
						response.string_value = "some other remodelling"
					when 'integer'
						response.integer_value = 1942
				end
				response.save
			end
		end
		response_set
	end

	def fill_out_survey(options={})
		response_set = Factory(:response_set,{
			:completed_at => Time.now
		}.merge(options))
		response_set.survey.sections.each do |section|
			section.questions.each do |question|
				next if question.answers.length <= 0
				response = Factory.build(:response, {
					:response_set => response_set,
					:question     => question,
					:answer => question.answers.first
				})
				case response.answer.response_class
					when 'string'||'text'
						response.string_value = "some text"
					when 'integer'
						response.integer_value = 1942
				end
				response.save
			end
		end
		response_set
	end

	def create_home_exposure_with_subject(options={})
		subject    = Factory(:subject,options[:subject]||{})
#		identifier = Factory(:identifier, :subject => subject)
		project = Project.find_or_create_by_code('HomeExposures')
		Factory(:enrollment, (options[:enrollment]||{}).merge(
			:subject => subject, :project => project ))
		subject
	end
	alias_method :create_hx_subject, :create_home_exposure_with_subject

	def create_hx_interview_subject(options={})
		subject = create_hx_subject
		identifier = Factory(:identifier, :subject => subject)
#		interview_type = Factory(:interview_type, 
#			:project => Project.find_or_create_by_code('HomeExposures'))
#		instrument_version = Factory(:instrument_version, 
#			:interview_type => interview_type)
		instrument = Factory(:instrument, 
			:project => Project.find_or_create_by_code('HomeExposures'))
		instrument_version = Factory(:instrument_version, 
			:instrument => instrument)
		interview = Factory(:interview, 
			:identifier => identifier,
			:instrument_version => instrument_version)
		subject
	end

	def create_subject(options = {})
		record = Factory.build(:subject,options)
		record.save
		record
	end

	def create_subjects(count=0,options={})
		subjects = []
		count.times{ subjects.push(create_subject(options)) }
		return subjects
	end

	def three_subjects_with_recruitment_priority
		project = Factory(:project)
		s1 = create_subject
		s2 = create_subject
		s3 = create_subject
		Factory(:enrollment, :project => project, :subject => s1,
			:recruitment_priority => 9)
		Factory(:enrollment, :project => project, :subject => s2,
			:recruitment_priority => 3)
		Factory(:enrollment, :project => project, :subject => s3,
			:recruitment_priority => 6)
		return [project,s1,s2,s3]
	end

	def create_subject_with_childid(childid)
		subject = create_subject
		Factory(:identifier, 
			:subject_id => subject.id, 
			:childid => childid )
		subject
	end
	
	def three_subjects_with_childid
		s1 = create_subject_with_childid('9')
		s2 = create_subject_with_childid('3')
		s3 = create_subject_with_childid('6')
		return [s1,s2,s3]
	end

	def create_subject_with_patid(patid)
		subject = create_subject
		Factory(:identifier, 
			:subject_id => subject.id, 
			:patid => patid )
		subject
	end
	
	def three_subjects_with_patid
		s1 = create_subject_with_patid('9')
		s2 = create_subject_with_patid('3')
		s3 = create_subject_with_patid('6')
		return [s1,s2,s3]
	end

	def create_subject_with_last_name(last_name)
		create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:last_name => last_name ))
	end
	
	def three_subjects_with_last_name
		s1 = create_subject_with_last_name('9')
		s2 = create_subject_with_last_name('3')
		s3 = create_subject_with_last_name('6')
		return [s1,s2,s3]
	end

	def create_subject_with_first_name(first_name)
		create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:first_name => first_name ))
	end
	
	def three_subjects_with_first_name
		s1 = create_subject_with_first_name('9')
		s2 = create_subject_with_first_name('3')
		s3 = create_subject_with_first_name('6')
		return [s1,s2,s3]
	end

	def create_subject_with_dob(dob)
		create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:dob => Time.parse(dob) ))
	end
	
	def three_subjects_with_dob
		s1 = create_subject_with_dob('12/31/2005')
		s2 = create_subject_with_dob('12/31/2001')
		s3 = create_subject_with_dob('12/31/2003')
		return [s1,s2,s3]
	end

end

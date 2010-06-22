module FactoryTestHelper

	def active_user(options={})
		u = Factory(:user, options)
		#	leave this special save here just in case I change things.
		#	although this would need changed for UCB CAS.
		#	u.save_without_session_maintenance
		#	u
	end
	alias_method :user, :active_user

	def admin_user(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('administrator')
		u
	end
	alias_method :admin, :admin_user

	def employee_user(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('employee')
		u
	end
	alias_method :employee, :employee_user

	def editor(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('editor')
		u
	end

	def moderator(options={})
		u = active_user(options)
		u.roles << Role.find_or_create_by_name('moderator')
		u
	end

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

	def create_home_exposure_with_subject
		s = Factory(:subject)
#		se = Factory(:study_event, :description => "Home Exposure")
		se = StudyEvent.find_or_create_by_description('Home Exposure')
		Factory(:project_subject, :subject => s, :study_event => se )
	end

end

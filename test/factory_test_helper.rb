module FactoryTestHelper

	def full_response(options={})
		survey = survey_section = question = answer = response_set = response = nil
		assert_difference('Survey.count',1) {
			survey = Factory(:survey)
		}
		assert_difference('Survey.count',0) {
		assert_difference('SurveySection.count',1) {
			survey_section = Factory(:survey_section, :survey => survey)
		} }
		assert_difference('Survey.count',0) {
		assert_difference('SurveySection.count',0) {
		assert_difference('Question.count',1) {
			question = Factory(:question, { 
				:survey_section => survey_section }.merge(options[:question]||{}))
		} } }
		assert_difference('Survey.count',0) {
		assert_difference('SurveySection.count',0) {
		assert_difference('Question.count',0) {
		assert_difference('Answer.count',1) {
			answer = Factory(:answer, { :question => question,
				:response_class => "answer" }.merge(options[:answer]||{}))
		} } } }
		assert_difference('Survey.count',0) {
		assert_difference('SurveySection.count',0) {
		assert_difference('Question.count',0) {
		assert_difference('Answer.count',0) {
		assert_difference('ResponseSet.count',1) {
			response_set = Factory(:response_set, {
				:survey => survey}.merge(options[:response_set]||{}))
		} } } } }
		assert_difference('Survey.count',0) {
		assert_difference('SurveySection.count',0) {
		assert_difference('Question.count',0) {
		assert_difference('Answer.count',0) {
		assert_difference('ResponseSet.count',0) {
		assert_difference('Response.count',1) {
			response = Factory(:response, {
				:response_set => response_set,
				:question => question, 
				:answer => answer}.merge(options[:response]||{})
			)
		} } } } } }
		response
	end

	def q_and_a_for(survey_section, options={})
		question = answer = nil
		assert_difference('Survey.count',0) {
		assert_difference('SurveySection.count',0) {
		assert_difference('Question.count',1) {
			question = Factory(:question, { 
				:survey_section => survey_section 
			}.merge(options[:question]||{}))
		} } }
		assert_difference('Survey.count',0) {
		assert_difference('SurveySection.count',0) {
		assert_difference('Question.count',0) {
		assert_difference('Answer.count',1) {
			Factory(:answer, { 
				:question => question,
				:response_class => "answer" 
			}.merge(options[:answer]||{}))
		} } } }
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
		response_set = nil
		assert ResponseSet.new.respond_to?(:subject)
		assert_difference('ResponseSet.count',1) {
			response_set = Factory(:response_set,{
				:completed_at => Time.now
			}.merge(options))
#puts response_set.survey.inspect
#puts response_set.subject.inspect
		}
		response_set.survey.sections.each do |section|
			section.questions.each do |question|
				next if question.answers.length <= 0
				response = nil
				assert_difference('Response.count',1) {
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
				}
			end
		end
		response_set
	end

end
ActiveSupport::TestCase.send(:include, FactoryTestHelper)

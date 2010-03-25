module FactoryTestHelper

	def active_user(options={})
		u = Factory(:user, options)
	end

	def admin_user(options={})
		u = active_user(options.merge(:role_name => "administrator"))
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

	def full_response_set(options={})
		survey = if options[:survey].is_a?(Survey)
			#	A survey and its q and a already exist.
			options[:survey]
		else
			#	assuming that its a hash
			s = Factory(:survey, options[:survey]||{} )
			survey_section = Factory(:survey_section, :survey => s )





			s
		end
		response_set = Factory(:response_set, {
			:survey => survey}.merge(options[:response_set]||{}))




		response_set
	end

end

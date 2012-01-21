require 'test_helper'

class InterviewsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Interview',
		:actions => [:show,:edit,:update,:destroy],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_interview_with_study_subject
	}
	def factory_attributes(options={})
		#	no attributes to trigger updated_at
		Factory.attributes_for(:interview,{
			:updated_at => Time.now
		}.merge(options))
	end

	assert_access_with_login({ 
		:logins => site_editors })
	assert_no_access_with_login({
		:logins => non_site_editors })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

protected

	def create_interview_with_study_subject(options={})
		assert_difference('Interview.count',1) {
		assert_difference('StudySubject.count',1) {
			@interview = create_interview(options)
			assert_not_nil @interview.id
			assert_not_nil @interview.study_subject
			assert_not_nil @interview.study_subject.id
		} }
		@interview
	end

end

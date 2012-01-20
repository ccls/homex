require 'test_helper'

class Followup::GiftCardsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_subject
	ASSERT_ACCESS_OPTIONS = {
		:model => 'GiftCard',
		:actions => [:index,:edit,:update,:show],
#		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_gift_card
	}
	def factory_attributes(options={})
		Factory.attributes_for(:gift_card,options)
	end

	assert_access_with_login({ 
		:logins => site_administrators })
	assert_no_access_with_login({ 
		:logins => non_site_administrators })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	site_administrators.each do |cu|

		test "study_subjects should be empty if none on edit" <<
				" with #{cu} login" do
			gift_card = Factory(:gift_card)
			login_as send(cu)
			get :edit, :id => gift_card.id
			assert_equal [], assigns(:study_subjects)
		end

		test "study_subjects should include homex complete without gift card on edit" <<
				" with #{cu} login" do
			gift_card = Factory(:gift_card)
			study_subject = Factory(:study_subject)
			Factory(:enrollment,
				:project => Project['HomeExposures'],
				:study_subject => study_subject)
			Factory(:homex_outcome,
				:sample_outcome => SampleOutcome['complete'],
				:interview_outcome => InterviewOutcome['complete'],
				:study_subject => study_subject)
			login_as send(cu)
			get :edit, :id => gift_card.id
			assert_equal [study_subject], assigns(:study_subjects)
		end

	end



#%w( superuser admin reader editor ).each do |u|
#
#	test "should download csv with #{u} login" do
#		login_as send(u)
#		get :index, :commit => 'download'
#		assert_response :success
#		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
#	end
#
#end
#
#%w( active_user ).each do |u|
#
#	test "should NOT download csv with #{u} login" do
#		login_as send(u)
#		get :index, :commit => 'download'
#		assert_redirected_to root_path
#		assert_not_nil flash[:error]
#	end
#
#end
#
#	test "should NOT download csv without login" do
#		get :index, :commit => 'download'
#		assert_redirected_to_login
#	end

end

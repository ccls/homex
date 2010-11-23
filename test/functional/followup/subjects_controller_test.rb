require File.dirname(__FILE__) + '/../../test_helper'

class Followup::SubjectsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_subject
	ASSERT_ACCESS_OPTIONS = {
		:model => 'Subject',
		:actions => [:index,:show,:edit],	#,:update],
#		:before => :create_home_exposure_subjects,
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_subject
	}
	def factory_attributes(options={})
		Factory.attributes_for(:subject,{
			:subject_type_id => Factory(:subject_type).id,
			:race_id => Factory(:race).id}.merge(options))
	end

#	This controller isn't exactly restful
#	and doesn't actually edit the subject.

	assert_access_with_login({ 
		:logins => [:superuser,:admin,:reader,:editor] })
	assert_no_access_with_login({ 
		:logins => [:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http


%w( superuser admin reader editor ).each do |u|

	test "should download csv with #{u} login" do
		login_as send(u)
		get :index, :commit => 'download'
		assert_response :success
		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
	end

	test "should create subject's hx_gift_card if none " <<
			"with #{u} login" do
		login_as send(u)
		subject = create_hx_subject
		gift_card = create_gift_card(:project => Project['HomeExposures'])
		assert_nil gift_card.subject
		assert_nil subject.hx_gift_card
		put :update, :id => subject.id, :gift_card => { :id => gift_card.id }
		assert_equal subject.reload.hx_gift_card, gift_card.reload
		assert_equal subject, assigns(:subject)
		assert_redirected_to followup_subject_path(subject)
	end

	test "should change subject's hx_gift_card if exists " <<
			"with #{u} login" do
		login_as send(u)
		subject = create_hx_subject
		gift_card_1 = create_gift_card(:project => Project['HomeExposures'])
		gift_card_2 = create_gift_card(:project => Project['HomeExposures'])
		assert_nil gift_card_1.subject
		assert_nil gift_card_2.subject
		assert_nil subject.hx_gift_card
		gift_card_1.update_attribute(:subject, subject)
		assert_not_nil gift_card_1.subject
		assert_nil     gift_card_2.subject
		assert_not_nil subject.reload.hx_gift_card
		put :update, :id => subject.id, :gift_card => { :id => gift_card_2.id }
		assert_nil     gift_card_1.reload.subject
		assert_not_nil gift_card_2.reload.subject
		assert_not_nil subject.reload.hx_gift_card
		assert_equal subject.reload.hx_gift_card, gift_card_2
		assert_equal subject, assigns(:subject)
		assert_redirected_to followup_subject_path(subject)
	end

end

%w( active_user ).each do |u|

	test "should NOT download csv with #{u} login" do
		login_as send(u)
		get :index, :commit => 'download'
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

end

	test "should NOT download csv without login" do
		get :index, :commit => 'download'
		assert_redirected_to_login
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class SurveyInvitationTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:subject,:survey)
	assert_should_belong_to(:response_set)
	assert_should_initially_belong_to(:subject,:survey)

	assert_should_require_unique(:subject_id, 
		:scope => :survey_id)

	test "should create survey_invitation" do
		assert_difference( "#{model_name}.count", 1 ) do
			survey_invitation = create_survey_invitation
			assert !survey_invitation.new_record?, 
				"#{survey_invitation.errors.full_messages.to_sentence}"
		end
	end

	test "should require token" do
		SurveyInvitation.any_instance.stubs(:create_token).returns(true)
		assert_difference( "#{model_name}.count", 0 ) do
			survey_invitation = create_survey_invitation
			assert survey_invitation.errors.on(:token)
		end
	end

	test "should require unique token" do
		si = create_survey_invitation
		SurveyInvitation.any_instance.stubs(:create_token).returns(true)
		assert_difference( "#{model_name}.count", 0 ) do
			survey_invitation = create_survey_invitation(
				:token      => si.token,
				:subject_id => si.subject_id,
				:survey_id  => si.survey_id )
			assert survey_invitation.errors.on(:token)
		end
	end

	test "should require response_set_id on update" do
		assert_difference( "#{model_name}.count", 1 ) do
			survey_invitation = create_survey_invitation
			survey_invitation.reload.update_attributes(:created_at => Time.now)
			assert survey_invitation.errors.on(:response_set_id)
		end
	end

	test "should not change token on update" do
		survey_invitation = create_survey_invitation
		token_before = survey_invitation.token
		Factory(:response_set, :survey_invitation => survey_invitation)
		token_after = survey_invitation.reload.token
		assert_equal token_before, token_after
	end

	test "should require unique response_set_id" do
		rs = Factory(:response_set)
		si = create_survey_invitation(:response_set_id => rs.id)
		assert_no_difference 'SurveyInvitation.count' do
			survey_invitation = create_survey_invitation(
				:response_set_id => si.response_set_id)
			assert survey_invitation.errors.on(:response_set_id)
		end
	end

	test "should create replacement invitation" do
		survey_invitation = create_survey_invitation
		subject = survey_invitation.subject
		survey = survey_invitation.survey
		before_id = subject.survey_invitations.first.id
		assert_difference( "#{model_name}.count", 0 ) do
			subject.recreate_survey_invitation(survey)
		end
		after_id = subject.reload.survey_invitations.first.id
		assert_not_equal before_id, after_id
	end

	test "should respond to email" do
		subject = Factory(:subject, 
			:pii_attributes => Factory.attributes_for(:pii) )
		survey_invitation = create_survey_invitation(:subject => subject)
		assert_not_nil survey_invitation.email
	end

end

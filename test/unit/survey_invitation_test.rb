require File.dirname(__FILE__) + '/../test_helper'

class SurveyInvitationTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:subject,:survey)

	test "should create survey_invitation" do
		assert_difference( 'SurveyInvitation.count', 1) do
			survey_invitation = create_survey_invitation
			assert !survey_invitation.new_record?, 
				"#{survey_invitation.errors.full_messages.to_sentence}"
		end
	end

	test "should require unique survey_id / subject_id" do
		si = create_survey_invitation
		assert_no_difference 'SurveyInvitation.count' do
			survey_invitation = create_survey_invitation(
				:subject_id => si.subject_id,
				:survey_id  => si.survey_id)
			#	because of the wording of the validation
			#	the error is on subject_id
			assert survey_invitation.errors.on(:subject_id)
		end
	end

	test "should require token" do
		SurveyInvitation.any_instance.stubs(:create_token).returns(true)
		assert_no_difference 'SurveyInvitation.count' do
			survey_invitation = create_survey_invitation
			assert survey_invitation.errors.on(:token)
		end
	end

	test "should require unique token" do
		si = create_survey_invitation
		SurveyInvitation.any_instance.stubs(:create_token).returns(true)
		assert_no_difference 'SurveyInvitation.count' do
			survey_invitation = create_survey_invitation(
				:token      => si.token,
				:subject_id => si.subject_id,
				:survey_id  => si.survey_id )
			assert survey_invitation.errors.on(:token)
		end
	end

	test "should require response_set_id on update" do
		assert_difference 'SurveyInvitation.count', 1 do
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
		assert_difference('SurveyInvitation.count', 0) do
			subject.recreate_survey_invitation(survey)
		end
		after_id = subject.reload.survey_invitations.first.id
		assert_not_equal before_id, after_id
	end

	test "should initially belong to subject" do
		survey_invitation = create_survey_invitation
		assert_not_nil survey_invitation.subject
	end

	test "should initially belong to survey" do
		survey_invitation = create_survey_invitation
		assert_not_nil survey_invitation.survey
	end

	test "should belong to response_set" do
		survey_invitation = create_survey_invitation
		assert_nil survey_invitation.response_set
		survey_invitation.response_set = Factory(:response_set)
		assert_not_nil survey_invitation.response_set
	end

	test "should respond to email" do
		subject = Factory(:subject, 
			:pii_attributes => Factory.attributes_for(:pii) )
		survey_invitation = create_survey_invitation(:subject => subject)
		assert_not_nil survey_invitation.email
	end

protected

	def create_survey_invitation(options = {})
		record = Factory.build(:survey_invitation,options)
		record.save
		record
	end
	alias_method :create_object, :create_survey_invitation

end

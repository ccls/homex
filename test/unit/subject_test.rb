require File.dirname(__FILE__) + '/../test_helper'

class SubjectTest < ActiveSupport::TestCase

	assert_should_have_many( :response_sets )
	assert_should_have_many( :survey_invitations )

	def sscount(subject_id,survey_id)
		SurveyInvitation.count(:conditions => {
			:study_subject_id => subject_id, :survey_id => survey_id })
	end

	test "should have one survey_invitation per survey" do
		subject = create_subject
		survey  = Factory(:survey)
		assert_difference("sscount(#{subject.id},#{survey.id})",1){
			Factory(:survey_invitation, {
				:subject => subject, :survey_id => survey.id })
		}
		assert_difference("sscount(#{subject.id},#{survey.id})",0){
		assert_raise(ActiveRecord::RecordInvalid){
			Factory(:survey_invitation, {
				:subject => subject, :survey_id => survey.id })
		} }
	end

	test "her_invitation should return home_exposure_survey invitation" do
		subject = create_subject
		assert_nil subject.her_invitation
		si = Factory(:survey_invitation, 
			:subject => subject,
			:survey  => Survey.first)
		assert_not_nil subject.her_invitation
	end

	test "should NOT destroy survey_invitations with subject" do
		subject = create_subject
		Factory(:survey_invitation, :subject => subject)
		Factory(:survey_invitation, :subject => subject)
		assert_difference( "#{model_name}.count", -1 ) {
		assert_difference('SurveyInvitation.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy response_sets with subject" do
		subject = create_subject
		Factory(:response_set, :subject => subject)
		Factory(:response_set, :subject => subject)
		assert_difference( "#{model_name}.count", -1 ) {
		assert_difference('ResponseSet.count',0) {
			subject.destroy
		} }
	end

	test "should return true response sets the same" do
		sets = create_survey_response_sets
		assert sets.first.subject.response_sets_the_same?
	end

	test "should return false response sets the same" do
		sets = create_survey_response_sets
		sets.last.responses.first.destroy
		assert !sets.first.subject.response_sets_the_same?
	end

	test "should raise error 1 response sets the same" do
		sets = create_survey_response_sets
		sets.last.destroy
		assert_raise(Subject::NotTwoResponseSets) {
			sets.first.subject.response_sets_the_same?
		}
	end

	test "should raise error 3 response sets the same" do
		sets = create_survey_response_sets
		fill_out_survey(:survey => sets.first.survey,
			:subject => sets.first.subject)
		assert_raise(Subject::NotTwoResponseSets) {
			sets.first.subject.response_sets_the_same?
		}
	end

	test "should return diffs on response set diffs" do
		sets = create_survey_response_sets
		sets.last.responses.first.destroy
		assert !sets.first.subject.response_set_diffs.blank?
	end

	test "should return empty diffs on response set diffs when the same" do
		sets = create_survey_response_sets
		assert sets.first.subject.response_set_diffs.blank?
	end

	test "should raise error 1 response set diffs" do
		sets = create_survey_response_sets
		sets.last.destroy
		assert_raise(Subject::NotTwoResponseSets) {
			sets.first.subject.response_set_diffs
		}
	end

	test "should raise error 3 response set diffs" do
		sets = create_survey_response_sets
		fill_out_survey(:survey => sets.first.survey,
			:subject => sets.first.subject)
		assert_raise(Subject::NotTwoResponseSets) {
			sets.first.subject.response_set_diffs
		}
	end

protected

	def create_survey_response_sets
		survey = Survey.find_by_access_code("home_exposure_survey")
		rs1 = fill_out_survey(:survey => survey)
		rs2 = fill_out_survey(:survey => survey,
			:subject => rs1.subject)
		[rs1.reload,rs2.reload]
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class SubjectTest < ActiveSupport::TestCase

	test "should create subject" do
		assert_difference( 'Race.count' ){
		assert_difference( 'SubjectType.count' ){
		assert_difference( 'Subject.count' ){
			subject = create_subject
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} } }
	end

	test "should create subject with pii" do
		assert_difference( 'Pii.count', 1) {
		assert_difference( 'Subject.count', 1) {
			subject = create_subject(
				:pii_attributes => Factory.attributes_for(:pii))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create subject with empty pii" do
		assert_difference( 'Pii.count', 0) {
		assert_difference( 'Subject.count', 0) {
			subject = create_subject( :pii_attributes => {})
			assert subject.errors.on(:pii_ssn)
			assert subject.errors.on(:pii_state_id_no)
		} }
	end

	test "should create subject with patient" do
		assert_difference( 'Patient.count', 1) {
		assert_difference( 'Subject.count', 1) {
			subject = create_subject(
				:patient_attributes => Factory.attributes_for(:patient))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

#	test "should NOT create subject with empty patient" do
#
##	patient has no requirements so it would actually work
##	TODO
#
#		pending
#
#	end

	test "should create subject with child_id" do
		assert_difference( 'ChildId.count', 1) {
		assert_difference( 'Subject.count', 1) {
			subject = create_subject(
				:child_id_attributes => Factory.attributes_for(:child_id))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create subject with empty child_id" do
		assert_difference( 'ChildId.count', 0) {
		assert_difference( 'Subject.count', 0) {
			subject = create_subject(
				:child_id_attributes => {} )
			assert subject.errors.on(:child_id_childid)
		} }
	end

	test "should require valid race" do
		assert_difference( 'Subject.count', 0) {
			subject = create_subject(:race_id => 0)
			assert subject.errors.on(:race)
		}
	end

	test "should require valid subject_type" do
		assert_difference( 'Subject.count', 0) {
			subject = create_subject(:subject_type_id => 0)
			assert subject.errors.on(:subject_type)
		}
	end

	test "should initially belong to race" do
		subject = create_subject
		assert_not_nil subject.race
	end

	test "should initially belong to subject_type" do
		subject = create_subject
		assert_not_nil subject.subject_type
	end

	def sscount(subject_id,survey_id)
		SurveyInvitation.count(:conditions => {
			:subject_id => subject_id, :survey_id => survey_id })
	end

	test "should have one survey_invitation per survey" do
		subject = create_subject
		survey  = Factory(:survey)
		assert_difference("sscount(#{subject.id},#{survey.id})",1){
			Factory(:survey_invitation, {
				:subject_id => subject.id, :survey_id => survey.id })
		}
		assert_difference("sscount(#{subject.id},#{survey.id})",0){
		assert_raise(ActiveRecord::RecordInvalid){
			Factory(:survey_invitation, {
				:subject_id => subject.id, :survey_id => survey.id })
		} }
	end

	test "should have many survey_invitations" do
		subject = create_subject
		assert_equal 0, subject.survey_invitations.length
		Factory(:survey_invitation, :subject_id => subject.id)
		assert_equal 1, subject.reload.survey_invitations.length
		Factory(:survey_invitation, :subject_id => subject.id)
		assert_equal 2, subject.reload.survey_invitations.length
	end

	test "should have one child_id" do
		subject = create_subject
		assert_nil subject.child_id
		Factory(:child_id, :subject_id => subject.id)
		assert_not_nil subject.reload.child_id
		subject.child_id.destroy
		assert_nil subject.reload.child_id
	end

	test "should have one pii" do
		subject = create_subject
		assert_nil subject.pii
		Factory(:pii, :subject_id => subject.id)
		assert_not_nil subject.reload.pii
		subject.pii.destroy
		assert_nil subject.reload.pii
	end

	test "should have one patient" do
		subject = create_subject
		assert_nil subject.patient
		Factory(:patient, :subject_id => subject.id)
		assert_not_nil subject.reload.patient
		subject.patient.destroy
		assert_nil subject.reload.patient
	end

	test "should have one home_exposure_response" do
		subject = create_subject
		assert_nil subject.home_exposure_response
		Factory(:home_exposure_response, :subject_id => subject.id)
		assert_not_nil subject.reload.home_exposure_response
		subject.home_exposure_response.destroy
		assert_nil subject.reload.home_exposure_response
	end

	test "should have many operational_events" do
		subject = create_subject
		assert_equal 0, subject.operational_events.length
		Factory(:operational_event, :subject_id => subject.id)
		assert_equal 1, subject.reload.operational_events.length
		Factory(:operational_event, :subject_id => subject.id)
		assert_equal 2, subject.reload.operational_events.length
	end

	test "should have many project_subjects" do
		subject = create_subject
		assert_equal 0, subject.project_subjects.length
		Factory(:project_subject, :subject_id => subject.id)
		assert_equal 1, subject.reload.project_subjects.length
		Factory(:project_subject, :subject_id => subject.id)
		assert_equal 2, subject.reload.project_subjects.length
	end

	test "should have many samples" do
		subject = create_subject
		assert_equal 0, subject.samples.length
		Factory(:sample, :subject_id => subject.id)
		assert_equal 1, subject.reload.samples.length
		Factory(:sample, :subject_id => subject.id)
		assert_equal 2, subject.reload.samples.length
	end

	test "should have many residences" do
		subject = create_subject
		assert_equal 0, subject.residences.length
		Factory(:residence, :subject_id => subject.id)
		assert_equal 1, subject.reload.residences.length
		Factory(:residence, :subject_id => subject.id)
		assert_equal 2, subject.reload.residences.length
	end

	test "should have many interview_events" do
		subject = create_subject
		assert_equal 0, subject.interview_events.length
		Factory(:interview_event, :subject_id => subject.id)
		assert_equal 1, subject.reload.interview_events.length
		Factory(:interview_event, :subject_id => subject.id)
		assert_equal 2, subject.reload.interview_events.length
	end

	test "should have many study_event_eligibilities" do
		subject = create_subject
		assert_equal 0, subject.study_event_eligibilities.length
		Factory(:study_event_eligibility, :subject_id => subject.id)
		assert_equal 1, subject.reload.study_event_eligibilities.length
		Factory(:study_event_eligibility, :subject_id => subject.id)
		assert_equal 2, subject.reload.study_event_eligibilities.length
	end

	test "should have many response_sets" do
		subject = create_subject
		assert_equal 0, subject.response_sets.length
		assert_equal 0, subject.reload.response_sets_count
		Factory(:response_set, :subject_id => subject.id)
		assert_equal 1, subject.reload.response_sets.length
		assert_equal 1, subject.reload.response_sets_count
		Factory(:response_set, :subject_id => subject.id)
		assert_equal 2, subject.reload.response_sets.length
		assert_equal 2, subject.reload.response_sets_count
	end

	test "should return nil ssn without pii" do
		subject = create_subject
		assert_nil subject.ssn
	end

	test "should return ssn with pii" do
		subject = Factory(:pii, :subject => create_subject).subject
		assert_not_nil subject.ssn
	end

	test "should return nil full_name without pii" do
		subject = create_subject
		assert_nil subject.full_name
	end

	test "should return full_name with pii" do
		subject = Factory(:pii, :subject => create_subject).subject
		assert_not_nil subject.full_name
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

	test "should be ineligible for invitation without email" do
		subject = create_subject
		assert !subject.is_eligible_for_invitation?
	end

	test "should be eligible for invitation with email" do
		subject = create_subject(
			:pii_attributes => Factory.attributes_for(:pii))
		assert subject.is_eligible_for_invitation?
	end


	test "should destroy patient on subject destroy" do
		assert_difference( 'Patient.count', 1) {
		assert_difference( 'Subject.count', 1) {
			@subject = create_subject(
				:patient_attributes => Factory.attributes_for(:patient))
		} }
		assert_difference( 'Patient.count', -1) {
		assert_difference( 'Subject.count', -1) {
			@subject.destroy
		} }
	end

	test "should destroy child_id on subject destroy" do
		assert_difference( 'ChildId.count', 1) {
		assert_difference( 'Subject.count', 1) {
			@subject = create_subject(
				:child_id_attributes => Factory.attributes_for(:child_id))
		} }
		assert_difference( 'ChildId.count', -1) {
		assert_difference( 'Subject.count', -1) {
			@subject.destroy
		} }
	end

	test "should destroy pii on subject destroy" do
		assert_difference( 'Pii.count', 1) {
		assert_difference( 'Subject.count', 1) {
			@subject = create_subject(
				:pii_attributes => Factory.attributes_for(:pii))
		} }
		assert_difference( 'Pii.count', -1) {
		assert_difference( 'Subject.count', -1) {
			@subject.destroy
		} }
	end

protected

	def create_survey_response_sets
		survey = Survey.find_by_access_code("home_exposure_survey")
		rs1 = fill_out_survey(:survey => survey)
		rs2 = fill_out_survey(:survey => survey,
			:subject => rs1.subject)
		[rs1.reload,rs2.reload]
	end

	def create_subject(options = {})
		record = Factory.build(:subject,options)
		record.save
		record
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class SubjectTest < ActiveSupport::TestCase

	test "should create subject" do
		assert_difference 'Subject.count' do
			subject = create_subject
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		end
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


	test "should create subject with patient" do

	end

	test "should create subject with child_id" do

	end


#	test "should require description" do
#		assert_no_difference 'Subject.count' do
#			subject = create_subject(:description => nil)
#			assert subject.errors.on(:description)
#		end
#	end

	test "should belong to race" do
		subject = create_subject
#		assert_nil subject.race
#		subject.race = Factory(:race)
		assert_not_nil subject.race
	end

	test "should belong to subject_type" do
		subject = create_subject
#		assert_nil subject.subject_type
#		subject.subject_type = Factory(:subject_type)
		assert_not_nil subject.subject_type
	end

	test "should have one survey_invitation" do
		subject = create_subject
		assert_nil subject.survey_invitation
		Factory(:survey_invitation, :subject_id => subject.id)
		assert_not_nil subject.reload.survey_invitation
		subject.survey_invitation.destroy
		assert_nil subject.reload.survey_invitation
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

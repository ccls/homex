require File.dirname(__FILE__) + '/../test_helper'

class SubjectTest < ActiveSupport::TestCase

	test "should create subject" do
		assert_difference 'Subject.count' do
			subject = create_subject
			assert !subject.new_record?, "#{subject.errors.full_messages.to_sentence}"
		end
	end

#	test "should require description" do
#		assert_no_difference 'Subject.count' do
#			subject = create_subject(:description => nil)
#			assert subject.errors.on(:description)
#		end
#	end

	test "should belong to race" do
		subject = create_subject
		assert_nil subject.race
		subject.race = Factory(:race)
		assert_not_nil subject.race
	end

	test "should belong to subject_type" do
		subject = create_subject
		assert_nil subject.subject_type
		subject.subject_type = Factory(:subject_type)
		assert_not_nil subject.subject_type
	end

	test "should have many operational_events" do
		subject = create_subject
		assert_equal 0, subject.operational_events.length
		subject.operational_events << Factory(:operational_event)
		assert_equal 1, subject.operational_events.length
		subject.operational_events << Factory(:operational_event)
		assert_equal 2, subject.reload.operational_events.length
	end

	test "should have many project_subjects" do
		subject = create_subject
		assert_equal 0, subject.project_subjects.length
		subject.project_subjects << Factory(:project_subject)
		assert_equal 1, subject.project_subjects.length
		subject.project_subjects << Factory(:project_subject)
		assert_equal 2, subject.reload.project_subjects.length
	end

	test "should have many samples" do
		subject = create_subject
		assert_equal 0, subject.samples.length
		subject.samples << Factory(:sample)
		assert_equal 1, subject.samples.length
		subject.samples << Factory(:sample)
		assert_equal 2, subject.reload.samples.length
	end

	test "should have many residences" do
		subject = create_subject
		assert_equal 0, subject.residences.length
		subject.residences << Factory(:residence)
		assert_equal 1, subject.residences.length
		subject.residences << Factory(:residence)
		assert_equal 2, subject.reload.residences.length
	end

	test "should have many interview_events" do
		subject = create_subject
		assert_equal 0, subject.interview_events.length
		subject.interview_events << Factory(:interview_event)
		assert_equal 1, subject.interview_events.length
		subject.interview_events << Factory(:interview_event)
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


protected

	def create_subject(options = {})
		record = Factory.build(:subject,options)
		record.save
		record
	end

end

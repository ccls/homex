require File.dirname(__FILE__) + '/../test_helper'

class StudyEventTest < ActiveSupport::TestCase

	test "should create study_event" do
		assert_difference 'StudyEvent.count' do
			study_event = create_study_event
			assert !study_event.new_record?, "#{study_event.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'StudyEvent.count' do
			study_event = create_study_event(:description => nil)
			assert study_event.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'StudyEvent.count' do
			study_event = create_study_event(:description => 'Hey')
			assert study_event.errors.on(:description)
		end
	end

	test "should have many operational_event_types" do
		study_event = create_study_event
		assert_equal 0, study_event.operational_event_types.length
		Factory(:operational_event_type, :study_event_id => study_event.id)
		assert_equal 1, study_event.reload.operational_event_types.length
		Factory(:operational_event_type, :study_event_id => study_event.id)
		assert_equal 2, study_event.reload.operational_event_types.length
	end

	test "should have many interview_types" do
		study_event = create_study_event
		assert_equal 0, study_event.interview_types.length
		Factory(:interview_type, :study_event_id => study_event.id)
		assert_equal 1, study_event.reload.interview_types.length
		Factory(:interview_type, :study_event_id => study_event.id)
		assert_equal 2, study_event.reload.interview_types.length
	end

	test "should have many study_event_eligibilities" do
		study_event = create_study_event
		assert_equal 0, study_event.study_event_eligibilities.length
		Factory(:study_event_eligibility, :study_event_id => study_event.id)
		assert_equal 1, study_event.reload.study_event_eligibilities.length
		Factory(:study_event_eligibility, :study_event_id => study_event.id)
		assert_equal 2, study_event.reload.study_event_eligibilities.length
	end

	test "should have many project_subjects" do
		study_event = create_study_event
		assert_equal 0, study_event.project_subjects.length
		Factory(:project_subject, :study_event_id => study_event.id)
		assert_equal 1, study_event.reload.project_subjects.length
		Factory(:project_subject, :study_event_id => study_event.id)
		assert_equal 2, study_event.reload.project_subjects.length
	end


protected

	def create_study_event(options = {})
		record = Factory.build(:study_event,options)
		record.save
		record
	end

end

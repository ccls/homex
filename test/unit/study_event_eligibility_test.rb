require File.dirname(__FILE__) + '/../test_helper'

class StudyEventEligibilityTest < ActiveSupport::TestCase

	test "should create study_event_eligibility" do
		assert_difference 'StudyEventEligibility.count' do
			study_event_eligibility = create_study_event_eligibility
			assert !study_event_eligibility.new_record?, 
				"#{study_event_eligibility.errors.full_messages.to_sentence}"
		end
	end

	test "should require valid subject_id" do
		assert_no_difference 'StudyEventEligibility.count' do
			study_event_eligibility = create_study_event_eligibility(
				:subject_id => 0)
			assert study_event_eligibility.errors.on(:subject_id)
		end
	end

	test "should require valid study_event_id" do
		assert_no_difference 'StudyEventEligibility.count' do
			study_event_eligibility = create_study_event_eligibility(
				:study_event_id => 0)
			assert study_event_eligibility.errors.on(:study_event_id)
		end
	end

	test "should require subject_id" do
		assert_no_difference 'StudyEventEligibility.count' do
			study_event_eligibility = create_study_event_eligibility(
				:subject_id => nil)
			assert study_event_eligibility.errors.on(:subject_id)
		end
	end

	test "should require study_event_id" do
		assert_no_difference 'StudyEventEligibility.count' do
			study_event_eligibility = create_study_event_eligibility(
				:study_event_id => nil)
			assert study_event_eligibility.errors.on(:study_event_id)
		end
	end

	test "should initially belong to subject" do
		study_event_eligibility = create_study_event_eligibility
		assert_not_nil study_event_eligibility.subject
	end

	test "should initially belong to study_event" do
		study_event_eligibility = create_study_event_eligibility
		assert_not_nil study_event_eligibility.study_event
	end

protected

	def create_study_event_eligibility(options = {})
		record = Factory.build(:study_event_eligibility,options)
		record.save
		record
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class ProjectSubjectTest < ActiveSupport::TestCase

	test "should create project_subject" do
		assert_difference 'ProjectSubject.count' do
			project_subject = create_project_subject
			assert !project_subject.new_record?, "#{project_subject.errors.full_messages.to_sentence}"
		end
	end

	test "should belong_to subject" do
		project_subject = create_project_subject

#		flunk subject

	end

	test "should belong_to ineligible_reason" do
		project_subject = create_project_subject
		assert_nil project_subject.ineligible_reason
		project_subject.ineligible_reason = Factory(:ineligible_reason)
		assert_not_nil project_subject.ineligible_reason
	end

	test "should belong_to refusal_reason" do
		project_subject = create_project_subject
		assert_nil project_subject.refusal_reason
		project_subject.refusal_reason = Factory(:refusal_reason)
		assert_not_nil project_subject.refusal_reason
	end

	test "should belong_to study_event" do
		project_subject = create_project_subject
		assert_nil project_subject.study_event
		project_subject.study_event = Factory(:study_event)
		assert_not_nil project_subject.study_event
	end


protected

	def create_project_subject(options = {})
		record = Factory.build(:project_subject,options)
		record.save
		record
	end

end

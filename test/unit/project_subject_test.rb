require File.dirname(__FILE__) + '/../test_helper'

class ProjectSubjectTest < ActiveSupport::TestCase

	test "should create project_subject" do
		assert_difference 'ProjectSubject.count' do
			project_subject = create_project_subject
			assert !project_subject.new_record?, 
				"#{project_subject.errors.full_messages.to_sentence}"
		end
	end

	test "should require valid subject_id" do
		assert_no_difference 'ProjectSubject.count' do
			project_subject = create_project_subject(:subject_id => 0)
			assert project_subject.errors.on(:subject)
		end
	end

	test "should require valid project_id" do
		assert_no_difference 'ProjectSubject.count' do
			project_subject = create_project_subject(:project_id => 0)
			assert project_subject.errors.on(:project)
		end
	end

	test "should require subject_id" do
		assert_no_difference 'ProjectSubject.count' do
			project_subject = create_project_subject(:subject_id => nil)
			assert project_subject.errors.on(:subject)
		end
	end

	test "should require project_id" do
		assert_no_difference 'ProjectSubject.count' do
			project_subject = create_project_subject(:project_id => nil)
			assert project_subject.errors.on(:project)
		end
	end

	test "should initially belong to a subject" do
		project_subject = create_project_subject
		assert_not_nil project_subject.subject
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

	test "should initially belong_to project" do
		project_subject = create_project_subject
		assert_not_nil project_subject.project
	end

protected

	def create_project_subject(options = {})
		record = Factory.build(:project_subject,options)
		record.save
		record
	end

end

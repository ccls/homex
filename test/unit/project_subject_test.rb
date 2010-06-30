require File.dirname(__FILE__) + '/../test_helper'

class ProjectSubjectTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:project,:subject)
	assert_should_belong_to(:ineligible_reason,:refusal_reason)

	test "should create project_subject" do
		assert_difference 'ProjectSubject.count' do
			project_subject = create_project_subject
			assert !project_subject.new_record?, 
				"#{project_subject.errors.full_messages.to_sentence}"
		end
	end

	test "should initially belong to a subject" do
		project_subject = create_project_subject
		assert_not_nil project_subject.subject
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
	alias_method :create_object, :create_project_subject

end

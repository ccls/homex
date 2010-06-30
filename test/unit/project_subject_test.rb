require File.dirname(__FILE__) + '/../test_helper'

class ProjectSubjectTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:project,:subject)
	assert_should_belong_to(:ineligible_reason,:refusal_reason)
	assert_should_initially_belong_to(:project,:subject)

	test "should create project_subject" do
		assert_difference 'ProjectSubject.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:project_subject,options)
		record.save
		record
	end

end

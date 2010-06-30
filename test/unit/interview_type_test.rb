require File.dirname(__FILE__) + '/../test_helper'

class InterviewTypeTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:interview_versions)
	assert_requires_valid_associations(:project)
	assert_should_initially_belong_to(:project)
	assert_should_require(:code,:description)
	assert_should_require_unique(:code,:description)

	test "should create interview_type" do
		assert_difference 'InterviewType.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'InterviewType.count' do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:interview_type,options)
		record.save
		record
	end

end

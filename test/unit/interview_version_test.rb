require File.dirname(__FILE__) + '/../test_helper'

class InterviewVersionTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:interviews)
	assert_should_belong_to(:language)
	assert_should_initially_belong_to(:interview_type)
	assert_requires_valid_associations(:interview_type)

	test "should create interview_version" do
		assert_difference 'InterviewVersion.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require code" do
		assert_no_difference 'InterviewVersion.count' do
			object = create_object(:code => nil)
			assert object.errors.on(:code)
		end
	end

	test "should require unique code" do
		iv = create_object
		assert_no_difference 'InterviewVersion.count' do
			object = create_object(
				:code => iv.code)
			assert object.errors.on(:code)
		end
	end

	test "should require description" do
		assert_no_difference 'InterviewVersion.count' do
			object = create_object(:description => nil)
			assert object.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'InterviewVersion.count' do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should require unique description" do
		iv = create_object
		assert_no_difference 'InterviewVersion.count' do
			object = create_object(
				:description => iv.description)
			assert object.errors.on(:description)
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:interview_version,options)
		record.save
		record
	end

end

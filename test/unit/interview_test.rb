require File.dirname(__FILE__) + '/../test_helper'

class InterviewTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:identifier)
	assert_should_belong_to(:address,:instrument_version,
		:interview_method,:language,:subject_relationship)
	assert_should_belong_to(:interviewer, :class_name => 'Person')

	assert_should_not_require_attributes(
		:address_id,
		:language_id,
		:interviewer_id,
		:instrument_version_id,
		:interview_method_id,
		:identifier_id
	)

	test "should NOT require valid address_id" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:address_id => 0)
			assert !object.errors.on(:address)
		end
	end

	test "should NOT require valid interviewer_id" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:interviewer_id => 0)
			assert !object.errors.on(:interviewer)
		end
	end

	test "should NOT require valid instrument_version_id" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:instrument_version_id => 0)
			assert !object.errors.on(:instrument_version_id)
		end
	end

	test "should NOT require valid interview_method_id" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:interview_method_id => 0)
			assert !object.errors.on(:interview_method_id)
		end
	end

	test "should NOT require valid language_id" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:language_id => 0)
			assert !object.errors.on(:language_id)
		end
	end

	test "should NOT require valid identifier_id" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:identifier_id => 0)
			assert !object.errors.on(:identifier_id)
		end
	end


	test "should require subject_relationship_other if " <<
			"subject_relationship == other" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:subject_relationship => SubjectRelationship['other'] )
			assert object.errors.on(:subject_relationship_other)
		end
	end

	test "should NOT ALLOW subject_relationship_other if " <<
			"subject_relationship != other" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:subject_relationship => Factory(:subject_relationship),
				:subject_relationship_other => 'asdfasdf' )
			assert object.errors.on(:subject_relationship_other)
		end
	end

end

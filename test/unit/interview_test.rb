require File.dirname(__FILE__) + '/../test_helper'

class InterviewTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:identifier)
	assert_should_belong_to( :address )
	assert_should_belong_to( :instrument_version )
	assert_should_belong_to( :interview_method )
	assert_should_belong_to( :language )
	assert_should_belong_to( :subject_relationship )
	assert_should_belong_to( :interviewer, :class_name => 'Person')

	assert_should_not_require_attributes(
		:address_id,
		:language_id,
		:interviewer_id,
		:instrument_version_id,
		:interview_method_id,
		:identifier_id
	)
	assert_should_require_attribute_length( :subject_relationship_other, :maximum => 250 )
	assert_should_require_attribute_length( :respondent_first_name,      :maximum => 250 )
	assert_should_require_attribute_length( :respondent_last_name,       :maximum => 250 )

	assert_requires_complete_date( :began_on )
	assert_requires_complete_date( :ended_on )

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

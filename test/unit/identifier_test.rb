require File.dirname(__FILE__) + '/../test_helper'

class IdentifierTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_many(:interviews)
	assert_should_initially_belong_to(:subject)
	assert_requires_valid_association(:subject)
	assert_should_require_attributes(
		:case_control_type,
		:childid,
		:orderno,
		:patid,
		:ssn,
		:subjectid,
		:subject_id
	)
	assert_should_require_unique_attributes(
		:childid,
		:ssn,
		:subject_id,
		:subjectid
	)
	assert_should_require_unique_attribute( :patid, 
		:scope => [:orderno,:case_control_type] )
	assert_should_not_require_attributes(
		:lab_no,
		:related_childid,
		:related_case_childid )
	assert_should_require_attribute_length( :case_control_type,    :maximum => 250 )
	assert_should_require_attribute_length( :lab_no,               :maximum => 250 )
	assert_should_require_attribute_length( :related_childid,      :maximum => 250 )
	assert_should_require_attribute_length( :related_case_childid, :maximum => 250 )


#	assert_should_protect_attributes(:subjectid)

	test "should pad subjectid with leading zeros" do
		identifier = Factory.build(:identifier)
		assert identifier.subjectid.length < 6 
		identifier.save
		assert identifier.subjectid.length == 6
	end 

	test "should create with all numeric ssn" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:ssn => 987654321)
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal '987654321', object.reload.ssn
		end
	end

	test "should create with string all numeric ssn" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:ssn => '987654321')
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal '987654321', object.reload.ssn
		end
	end

	test "should create with string standard format ssn" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:ssn => '987-65-4321')
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal '987654321', object.reload.ssn
		end
	end

	test "should require 9 digits in ssn" do
		%w( 12345678X 12345678 1-34-56-789 ).each do |invalid_ssn|
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:ssn => invalid_ssn)
				assert object.errors.on(:ssn)
			end
		end
	end

end

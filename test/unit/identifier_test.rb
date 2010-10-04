require File.dirname(__FILE__) + '/../test_helper'

class IdentifierTest < ActiveSupport::TestCase

	assert_should_have_many(:interviews)
	assert_should_initially_belong_to(:subject)
	assert_should_require(
		:case_control_type,
		:childid,
		:orderno,
		:patid,
		:ssn,
		:subjectid,
		:subject_id
	)
	assert_should_require_unique(
		:childid,
		:ssn,
		:subject_id,
		:subjectid
	)
	assert_should_require_unique :patid, 
		:scope => [:orderno,:case_control_type]

#	assert_should_protect_attributes(:subjectid)

	test "should create identifier" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should pad subjectid with leading zeros" do
		identifier = Factory.build(:identifier)
		assert identifier.subjectid.length < 6 
		identifier.save
		assert identifier.subjectid.length == 6
	end 

	test "should require valid subject_id" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:subject_id => 0)
			assert object.errors.on(:subject)
		end
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

#	test "should require 1 char orderno" do
#		assert_no_difference 'Identifier.count' do
#			object = create_object(:orderno => '12')
#			assert object.errors.on(:orderno)
#		end
#	end

#	test "should require 1 DIGIT orderno" do
#		assert_no_difference 'Identifier.count' do
#			object = create_object(:orderno => 'A')
#			assert object.errors.on(:orderno)
#		end
#	end

	test "should require 9 digits in ssn" do
		%w( 12345678X 12345678 1-34-56-789 ).each do |invalid_ssn|
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:ssn => invalid_ssn)
				assert object.errors.on(:ssn)
			end
		end
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class PiiTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_belong_to(:subject)
	assert_should_require_attributes(:state_id_no,:dob)
	assert_should_require_unique_attributes(:state_id_no,:email)
	assert_should_not_require_attributes(
		:subject_id,
		:first_name,
		:middle_name,
		:last_name,
		:died_on,
		:mother_first_name,
		:mother_middle_name,
		:mother_maiden_name,
		:mother_last_name,
		:father_first_name,
		:father_middle_name,
		:father_last_name,
		:email )

	assert_requires_complete_date( :dob, :died_on )

	#
	#	subject uses accepts_attributes_for :pii
	#	so the pii can't require subject_id on create
	#	or this test fails.
	#
	test "should require subject_id on update" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object
			object.reload.update_attributes(:first_name => "New First Name")
			assert object.errors.on(:subject)
		end
	end

	test "should require unique subject_id" do
		subject = Factory(:subject)
		create_object(:subject => subject)
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:subject => subject)
			assert object.errors.on(:subject_id)
		end
	end

	test "should allow multiple blank email" do
		create_object(:email => '  ')
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:email => ' ')
		end
	end

	test "should require properly formated email address" do
		assert_difference( "#{model_name}.count", 0 ) do
			%w( asdf me@some@where.com ).each do |bad_email|
				object = create_object(:email => bad_email)
				assert object.errors.on(:email)
			end
		end
		assert_difference( "#{model_name}.count", 1 ) do
			%w( me@some.where.com ).each do |good_email|
				object = create_object(:email => good_email)
				assert !object.errors.on(:email)
			end
		end
	end

	test "should return dob as a date NOT time" do
		object = create_object
		assert_changes("Pii.find(#{object.id}).dob") {
			object.update_attribute(:dob, Chronic.parse('tomorrow at noon'))
		}
		assert !object.new_record?
		assert_not_nil object.dob
		assert object.dob.is_a?(Date)
		assert_equal object.dob, object.dob.to_date
	end

	test "should parse a properly formatted date" do
		#	Chronic won't parse this correctly,
		#	but Date.parse will. ???
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(
				:dob => Chronic.parse("January 1 2001"))
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

end

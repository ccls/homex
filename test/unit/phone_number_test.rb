require File.dirname(__FILE__) + '/../test_helper'

class PhoneNumberTest < ActiveSupport::TestCase

	assert_should_act_as_list :scope => :subject_id
	assert_should_initially_belong_to :subject, :phone_type

	test "should require properly formated phone number" do
		[ 'asdf', 'me@some@where.com','12345678','12345678901' 
		].each do |bad_phone|
			assert_difference( 'PhoneNumber.count', 0 ) do
				object = create_object(:phone_number => bad_phone)
				assert object.errors.on(:phone_number)
			end
		end
		[ "(123)456-7890", "1234567890" ].each do |good_phone|
			assert_difference( 'PhoneNumber.count', 1 ) do
				object = create_object(:phone_number => good_phone)
				assert !object.errors.on(:phone_number)
				assert object.reload.phone_number =~ /\A\(\d{3}\)\s+\d{3}-\d{4}\z/
			end
		end
	end

	test "should NOT require why_invalid if is_valid is true" do
		assert_difference 'PhoneNumber.count', 1 do
			object = create_object(:is_valid => true)
		end
	end

	test "should require why_invalid if is_valid is false" do
		assert_difference 'PhoneNumber.count', 0 do
			object = create_object(:is_valid => false)
			assert object.errors.on(:why_invalid)
		end
	end

	test "should NOT require how_verified if is_verified is false" do
		assert_difference 'PhoneNumber.count', 1 do
			object = create_object(:is_verified => false)
		end
	end

	test "should require how_verified if is_verified is true" do
		assert_difference 'PhoneNumber.count', 0 do
			object = create_object(:is_verified => true)
			assert object.errors.on(:how_verified)
		end
	end

	test "should NOT set verified_on if is_verified NOT changed to true" do
		object = create_object(:is_verified => false)
		assert_nil object.verified_on
	end

	test "should set verified_on if is_verified changed to true" do
		object = create_object(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil object.verified_on
	end

	test "should set verified_on to NIL if is_verified changed to false" do
		object = create_object(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil object.verified_on
		object.update_attributes(:is_verified => false)
		assert_nil object.verified_on
	end

	test "should NOT set verified_by_id if is_verified NOT changed to true" do
		object = create_object(:is_verified => false)
		assert_nil object.verified_by_id
	end

	test "should set verified_by_id if is_verified changed to true" do
		object = create_object(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil object.verified_by_id
	end

	test "should set verified_by_id to NIL if is_verified changed to false" do
		object = create_object(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil object.verified_by_id
		object.update_attributes(:is_verified => false)
		assert_nil object.verified_by_id
	end

protected

	def create_object(options={})
		record = Factory.build(:phone_number,options)
		record.save
		record
	end

end

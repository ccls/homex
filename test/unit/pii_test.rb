require File.dirname(__FILE__) + '/../test_helper'

class PiiTest < ActiveSupport::TestCase

	assert_should_belong_to(:subject)
	assert_should_require(:state_id_no,:dob)
	assert_should_require_unique(:state_id_no,:email)

	test "should create pii" do
		assert_difference 'Pii.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	#
	#	subject uses accepts_attributes_for :pii
	#	so the pii can't require subject_id on create
	#	or this test fails.
	#
	test "should require subject_id on update" do
		assert_difference 'Pii.count', 1 do
			object = create_object
			object.reload.update_attributes(:first_name => "New First Name")
			assert object.errors.on(:subject)
		end
	end

	test "should require unique subject_id" do
		subject = Factory(:subject)
		create_object(:subject => subject)
		assert_difference( 'Pii.count', 0 ) do
			object = create_object(:subject => subject)
			assert object.errors.on(:subject_id)
		end
	end

	test "should allow multiple blank email" do
		create_object(:email => '  ')
		assert_difference('Pii.count',1) do
			object = create_object(:email => ' ')
		end
	end

	test "should require properly formated email address" do
		assert_difference( 'Pii.count', 0 ) do
			%w( asdf me@some@where.com ).each do |bad_email|
				object = create_object(:email => bad_email)
				assert object.errors.on(:email)
			end
		end
		assert_difference( 'Pii.count', 1 ) do
			%w( me@some.where.com ).each do |good_email|
				object = create_object(:email => good_email)
				assert !object.errors.on(:email)
			end
		end
	end

#	test "should require properly formated phone numbers" do
#		[ :phone_primary, :phone_alternate, :phone_alternate_2,
#			:phone_alternate_3 ].each do |phone_field|
#			[ 'asdf', 'me@some@where.com','12345678','12345678901' 
#			].each do |bad_phone|
#				assert_difference( 'Pii.count', 0 ) do
#					object = create_object(phone_field => bad_phone)
#					assert object.errors.on(phone_field)
#				end
#			end
#			[ "(123)456-7890", "1234567890" ].each do |good_phone|
#				assert_difference( 'Pii.count', 1 ) do
#					object = create_object(phone_field => good_phone)
#					assert !object.errors.on(phone_field)
#					assert object.reload.send(phone_field
#						) =~ /\A\(\d{3}\)\s+\d{3}-\d{4}\z/
#				end
#			end
#		end
#	end

	test "should return dob as a date NOT time" do
#	This used to work, but now doesn't ????
#		object = create_object(:dob => nil, :dob_string =>  "tomorrow at noon")
		object = create_object
		dob_before = object.dob
		object.update_attribute(:dob_string, "tomorrow at noon")
		dob_after = object.dob
		assert_not_equal dob_before, dob_after
		assert !object.new_record?
		assert_not_nil object.dob
		assert object.dob.is_a?(Date)
		assert_equal object.dob, object.dob.to_date
		assert_equal object.dob.strftime("%m/%d/%Y"), object.dob_string
	end

	test "should parse a properly formatted date" do
		#	Chronic won't parse this correctly,
		#	but Date.parse will. ???
		assert_difference( 'Pii.count', 1 ) do
			object = create_object(
				:dob => nil, 
				:dob_string =>  "January 1, 2001")
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:pii,options)
		record.save
		record
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class PhoneNumberTest < ActiveSupport::TestCase

	assert_should_act_as_list :scope => :subject_id
	assert_should_belong_to :subject

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

protected

	def create_object(options={})
		record = Factory.build(:phone_number,options)
		record.save
		record
	end

end

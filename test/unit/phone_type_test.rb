require File.dirname(__FILE__) + '/../test_helper'

class PhoneTypeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:phone_numbers)
	assert_should_require(:code)
	assert_should_require_unique(:code)

#	test "should create phone_type" do
#		assert_difference( "#{model_name}.count", 1 ) do
#			object = create_object
#			assert !object.new_record?, 
#				"#{object.errors.full_messages.to_sentence}"
#		end
#	end

	test "should require 4 char code" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:code => 'Hey')
			assert object.errors.on(:code)
		end
	end

	test "should return code as to_s" do
		object = create_object
		assert_equal object.code, "#{object}"
	end

end

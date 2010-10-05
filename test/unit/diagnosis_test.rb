require File.dirname(__FILE__) + '/../test_helper'

class DiagnosisTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes(:code,:description)
	assert_should_require_unique_attributes(:code,:description)
	assert_should_act_as_list


	test "should require 3 char description" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:description => 'Hi')
			assert object.errors.on(:description)
		end
	end

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class StateTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_require(:code,:name,:fips_state_code,:fips_country_code)
	assert_should_require_unique(:code,:name,:fips_state_code)

	test "should create state" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

end

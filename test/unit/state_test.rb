require File.dirname(__FILE__) + '/../test_helper'

class StateTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_require_attributes(
		:code,:name,:fips_state_code,:fips_country_code)
	assert_should_require_unique_attributes(
		:code,:name,:fips_state_code)

end

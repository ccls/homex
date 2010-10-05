require File.dirname(__FILE__) + '/../test_helper'

class RaceTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:subjects)
	assert_should_require_attributes(:code,:description)
	assert_should_require_unique_attributes(:code,:description)


	test "should require 4 char description" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should return name as to_s" do
		object = create_object
		assert_equal object.name, "#{object}"
	end

	test "should find by code with ['string']" do
		object = Race['1']
		assert object.is_a?(Race)
	end

	test "should find by code with [:symbol]" do
		object = Race['1'.to_sym]	#	:1 is no good, but '1'.to_sym is OK
		assert object.is_a?(Race)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(Race::NotFound) {
#			object = Race['idonotexist']
#		}
#	end

end

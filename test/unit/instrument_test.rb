require File.dirname(__FILE__) + '/../test_helper'

class InstrumentTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:instrument_versions)
	assert_should_belong_to(:interview_method)
	assert_should_initially_belong_to(:project)
#	assert_requires_valid_association(:project)
	assert_should_require_attributes(:code,:name,:description)
	assert_should_require_unique_attributes(:code,:description)

	assert_requires_complete_date(:began_use_on,:ended_use_on)

	test "should require 4 char description" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	#	unfortunately name is NOT unique so should change this
	test "should return name as to_s" do
		object = create_object
		assert_equal object.name, "#{object}"
	end

end

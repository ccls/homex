require File.dirname(__FILE__) + '/../test_helper'

class DataSourceTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:addresses)

#	test "should create data_source" do
#		assert_difference( "#{model_name}.count", 1 ) do
#			object = create_object
#			assert !object.new_record?, 
#				"#{object.errors.full_messages.to_sentence}"
#		end
#	end

end

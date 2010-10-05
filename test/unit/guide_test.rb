require File.dirname(__FILE__) + '/../test_helper'

class GuideTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_unique(:action,
		:scope => :controller)

#	test "should create guide" do
#		assert_difference( "#{model_name}.count", 1 ) do
#			object = create_object
#			assert !object.new_record?, 
#				"#{object.errors.full_messages.to_sentence}"
#		end
#	end

end

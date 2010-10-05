require File.dirname(__FILE__) + '/../test_helper'

class ExportTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:patid,:childid)
	assert_should_require_unique(:patid,:childid)

#	test "should create export" do
#		assert_difference( "#{model_name}.count", 1 ) do
#			object = create_object
#			assert !object.new_record?, 
#				"#{object.errors.full_messages.to_sentence}"
#		end
#	end

end

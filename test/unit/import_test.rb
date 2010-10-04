require File.dirname(__FILE__) + '/../test_helper'

class ImportTest < ActiveSupport::TestCase

	test "should create import" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

end

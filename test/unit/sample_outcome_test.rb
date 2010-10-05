require File.dirname(__FILE__) + '/../test_helper'

class SampleOutcomeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:homex_outcomes)
	assert_should_require(:code)
	assert_should_require_unique(:code)

#	test "should create sample_outcome" do
#		assert_difference( "#{model_name}.count", 1 ) do
#			object = create_object
#			assert !object.new_record?, 
#				"#{object.errors.full_messages.to_sentence}"
#		end
#	end

	test "should return description as to_s" do
		object = create_object(:description => "Description")
		assert_equal object.description,
			"#{object}"
	end

	test "should find by code with ['string']" do
		object = SampleOutcome['complete']
		assert object.is_a?(SampleOutcome)
	end

	test "should find by code with [:symbol]" do
		object = SampleOutcome[:complete]
		assert object.is_a?(SampleOutcome)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(SampleOutcome::NotFound) {
#			object = SampleOutcome['idonotexist']
#		}
#	end

end

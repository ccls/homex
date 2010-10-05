require File.dirname(__FILE__) + '/../test_helper'

class InterviewMethodTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:interviews,:instruments)
	assert_should_require_attributes(:code,:description)
	assert_should_require_unique_attributes(:code,:description)


	test "should require 4 char description" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end


	test "should find by code with ['string']" do
		object = InterviewMethod['other']
		assert object.is_a?(InterviewMethod)
	end

	test "should find by code with [:symbol]" do
		object = InterviewMethod[:other]
		assert object.is_a?(InterviewMethod)
	end

	test "should find random" do
		object = InterviewMethod.random()
		assert object.is_a?(InterviewMethod)
	end

	test "should return nil on random when no records" do
		InterviewMethod.stubs(:count).returns(0)
		object = InterviewMethod.random()
		assert_nil object
	end

end

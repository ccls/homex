require File.dirname(__FILE__) + '/../test_helper'

class InterviewOutcomeTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:homex_outcomes)
	assert_should_require(:code)
	assert_should_require_unique(:code)

	test "should create interview_outcome" do
		assert_difference 'InterviewOutcome.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should return description as to_s" do
		object = create_object(:description => "Description")
		assert_equal object.description,
			"#{object}"
	end

protected

	def create_object(options = {})
		record = Factory.build(:interview_outcome,options)
		record.save
		record
	end

end

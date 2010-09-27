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

	test "should find by code with []" do
		object = InterviewOutcome['complete']
		assert object.is_a?(InterviewOutcome)
	end

	test "should raise error if not found by code with []" do
		assert_raise(InterviewOutcome::NotFound) {
			object = InterviewOutcome['idonotexist']
		}
	end

protected

	def create_object(options = {})
		record = Factory.build(:interview_outcome,options)
		record.save
		record
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class HomexOutcomeTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_initially_belong_to(:subject)
	assert_should_require(:subject_id)
	assert_should_require_unique(:subject_id)

	test "should create homex_outcome" do
		assert_difference 'HomexOutcome.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

#	test "should return description as to_s" do
#		object = create_object
#		assert_equal object.description,
#			"#{object}"
#	end

protected

	def create_object(options = {})
		record = Factory.build(:homex_outcome,options)
		record.save
		record
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class ProjectOutcomeTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_require(:code)
	assert_should_require_unique(:code)

	test "should create project_outcome" do
		assert_difference 'ProjectOutcome.count' do
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
		record = Factory.build(:project_outcome,options)
		record.save
		record
	end

end
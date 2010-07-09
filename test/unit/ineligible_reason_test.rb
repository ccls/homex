require File.dirname(__FILE__) + '/../test_helper'

class IneligibleReasonTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:enrollments)
	assert_should_require(:code,:description)
	assert_should_require_unique(:code,:description)

	test "should create ineligible_reason" do
		assert_difference 'IneligibleReason.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'IneligibleReason.count' do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should return code as to_s" do
		object = create_object
		assert_equal object.code, "#{object}"
	end

protected

	def create_object(options = {})
		record = Factory.build(:ineligible_reason,options)
		record.save
		record
	end

end

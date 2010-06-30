require File.dirname(__FILE__) + '/../test_helper'

class IneligibleReasonTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:project_subjects)

	test "should create ineligible_reason" do
		assert_difference 'IneligibleReason.count' do
			ineligible_reason = create_ineligible_reason
			assert !ineligible_reason.new_record?, 
				"#{ineligible_reason.errors.full_messages.to_sentence}"
		end
	end

	test "should require code" do
		assert_no_difference 'IneligibleReason.count' do
			ineligible_reason = create_ineligible_reason(:code => nil)
			assert ineligible_reason.errors.on(:code)
		end
	end

	test "should require unique code" do
		ir = create_ineligible_reason
		assert_no_difference 'IneligibleReason.count' do
			ineligible_reason = create_ineligible_reason(
				:code => ir.code)
			assert ineligible_reason.errors.on(:code)
		end
	end

	test "should require description" do
		assert_no_difference 'IneligibleReason.count' do
			ineligible_reason = create_ineligible_reason(:description => nil)
			assert ineligible_reason.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'IneligibleReason.count' do
			ineligible_reason = create_ineligible_reason(:description => 'Hey')
			assert ineligible_reason.errors.on(:description)
		end
	end

	test "should require unique description" do
		ir = create_ineligible_reason
		assert_no_difference 'IneligibleReason.count' do
			ineligible_reason = create_ineligible_reason(
				:description => ir.description)
			assert ineligible_reason.errors.on(:description)
		end
	end

protected

	def create_ineligible_reason(options = {})
		record = Factory.build(:ineligible_reason,options)
		record.save
		record
	end
	alias_method :create_object, :create_ineligible_reason

end

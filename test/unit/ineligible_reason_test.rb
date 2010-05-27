require File.dirname(__FILE__) + '/../test_helper'

class IneligibleReasonTest < ActiveSupport::TestCase

	test "should create ineligible_reason" do
		assert_difference 'IneligibleReason.count' do
			ineligible_reason = create_ineligible_reason
			assert !ineligible_reason.new_record?, 
				"#{ineligible_reason.errors.full_messages.to_sentence}"
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

	test "should have many project_subjects" do
		ineligible_reason = create_ineligible_reason
		assert_equal 0, ineligible_reason.project_subjects.length
		ineligible_reason.project_subjects << Factory(:project_subject)
		assert_equal 1, ineligible_reason.project_subjects.length
		ineligible_reason.project_subjects << Factory(:project_subject)
		assert_equal 2, ineligible_reason.reload.project_subjects.length
	end

	test "should act as list" do
		ineligible_reason = create_ineligible_reason
		assert_equal 1, ineligible_reason.position
		ineligible_reason = create_ineligible_reason
		assert_equal 2, ineligible_reason.position
	end

protected

	def create_ineligible_reason(options = {})
		record = Factory.build(:ineligible_reason,options)
		record.save
		record
	end

end

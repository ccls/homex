require File.dirname(__FILE__) + '/../test_helper'

class IneligibleReasonTest < ActiveSupport::TestCase

	test "should create ineligible_reason" do
		assert_difference 'IneligibleReason.count' do
			ineligible_reason = create_ineligible_reason
			assert !ineligible_reason.new_record?, "#{ineligible_reason.errors.full_messages.to_sentence}"
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


	test "should have many study_events_subjects" do

#		flunk

	end


protected

	def create_ineligible_reason(options = {})
		record = Factory.build(:ineligible_reason,options)
		record.save
		record
	end

end

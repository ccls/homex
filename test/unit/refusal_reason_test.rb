require File.dirname(__FILE__) + '/../test_helper'

class RefusalReasonTest < ActiveSupport::TestCase

	test "should create refusal_reason" do
		assert_difference 'RefusalReason.count' do
			refusal_reason = create_refusal_reason
			assert !refusal_reason.new_record?, "#{refusal_reason.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'RefusalReason.count' do
			refusal_reason = create_refusal_reason(:description => nil)
			assert refusal_reason.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'RefusalReason.count' do
			refusal_reason = create_refusal_reason(:description => 'Hey')
			assert refusal_reason.errors.on(:description)
		end
	end


	test "should have many study_events_subjects" do

#		flunk

	end


protected

	def create_refusal_reason(options = {})
		record = Factory.build(:refusal_reason,options)
		record.save
		record
	end

end

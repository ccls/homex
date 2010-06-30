require File.dirname(__FILE__) + '/../test_helper'

class RefusalReasonTest < ActiveSupport::TestCase

	assert_should_have_many(:project_subjects)

	test "should create refusal_reason" do
		assert_difference 'RefusalReason.count' do
			refusal_reason = create_refusal_reason
			assert !refusal_reason.new_record?, 
				"#{refusal_reason.errors.full_messages.to_sentence}"
		end
	end

	test "should require code" do
		assert_no_difference 'RefusalReason.count' do
			refusal_reason = create_refusal_reason(:code => nil)
			assert refusal_reason.errors.on(:code)
		end
	end

	test "should require unique code" do
		rr = create_refusal_reason
		assert_no_difference 'RefusalReason.count' do
			refusal_reason = create_refusal_reason(
				:code => rr.code )
			assert refusal_reason.errors.on(:code)
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

	test "should require unique description" do
		rr = create_refusal_reason
		assert_no_difference 'RefusalReason.count' do
			refusal_reason = create_refusal_reason(
				:description => rr.description )
			assert refusal_reason.errors.on(:description)
		end
	end

protected

	def create_refusal_reason(options = {})
		record = Factory.build(:refusal_reason,options)
		record.save
		record
	end
	alias_method :create_object, :create_refusal_reason

end

require File.dirname(__FILE__) + '/../test_helper'

class HomexOutcomeTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_belong_to(:subject)

	test "should create homex_outcome" do
		assert_difference 'HomexOutcome.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	#
	#	subject uses accepts_attributes_for :pii
	#	so the pii can't require subject_id on create
	#	or this test fails.
	#
	test "should require subject_id on update" do
		assert_difference 'HomexOutcome.count', 1 do
			object = create_object
			object.reload.update_attributes(:updated_at => Time.now)
			assert object.errors.on(:subject)
		end
	end

	test "should require unique subject_id" do
		subject = Factory(:subject)
		create_object(:subject => subject)
		assert_difference( 'HomexOutcome.count', 0 ) do
			object = create_object(:subject => subject)
			assert object.errors.on(:subject_id)
		end
	end

	test "should require interview_outcome_on if interview_outcome_id?" do
		assert_difference('HomexOutcome.count',0) do
			object = create_object(
				:interview_outcome_on => nil,
				:interview_outcome_id => InterviewOutcome.first.id)
			assert object.errors.on(:interview_outcome_on)
		end
	end

	test "should require sample_outcome_on if sample_outcome_id?" do
		assert_difference('HomexOutcome.count',0) do
			object = create_object(
				:sample_outcome_on => nil,
				:sample_outcome_id => SampleOutcome.first.id)
			assert object.errors.on(:sample_outcome_on)
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:homex_outcome,options)
		record.save
		record
	end

end

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

	test "should create operational event when interview scheduled" do
		object = create_complete_object
		past_date = Chronic.parse('Jan 15 2003').to_date
		assert_difference('OperationalEvent.count',1) do
			object.update_attributes(
				:interview_outcome_on => past_date,
				:interview_outcome => InterviewOutcome['scheduled'])
		end
		oe = OperationalEvent.last
		assert_equal 'scheduled', oe.operational_event_type.code
		assert_equal past_date,   oe.occurred_on
		assert_equal object.subject_id, oe.enrollment.subject_id
	end

	test "should create operational event when interview completed" do
		object = create_complete_object
		past_date = Chronic.parse('Jan 15 2003').to_date
		assert_difference('OperationalEvent.count',1) do
			object.update_attributes(
				:interview_outcome_on => past_date,
				:interview_outcome => InterviewOutcome['complete'])
		end
		oe = OperationalEvent.last
		assert_equal 'iv_complete', oe.operational_event_type.code
		assert_equal past_date,   oe.occurred_on
		assert_equal object.subject_id, oe.enrollment.subject_id
	end

	test "should create operational event when sample kit sent" do
		object = create_complete_object
		past_date = Chronic.parse('Jan 15 2003').to_date
		assert_difference('OperationalEvent.count',1) do
			object.update_attributes(
				:sample_outcome_on => past_date,
				:sample_outcome => SampleOutcome['sent'])
		end
		oe = OperationalEvent.last
		assert_equal 'kit_sent', oe.operational_event_type.code
		assert_equal past_date,  oe.occurred_on
		assert_equal object.subject_id, oe.enrollment.subject_id
	end

	test "should create operational event when sample received" do
		object = create_complete_object
		past_date = Chronic.parse('Jan 15 2003').to_date
		assert_difference('OperationalEvent.count',1) do
			object.update_attributes(
				:sample_outcome_on => past_date,
				:sample_outcome => SampleOutcome['received'])
		end
		oe = OperationalEvent.last
		assert_equal 'sample_received', oe.operational_event_type.code
		assert_equal past_date,  oe.occurred_on
		assert_equal object.subject_id, oe.enrollment.subject_id
	end

	test "should create operational event when sample complete" do
		object = create_complete_object
		past_date = Chronic.parse('Jan 15 2003').to_date
		assert_difference('OperationalEvent.count',1) do
			object.update_attributes(
				:sample_outcome_on => past_date,
				:sample_outcome => SampleOutcome['complete'])
		end
		oe = OperationalEvent.last
		assert_equal 'sample_complete', oe.operational_event_type.code
		assert_equal past_date,  oe.occurred_on
		assert_equal object.subject_id, oe.enrollment.subject_id
	end

protected

	def create_object(options = {})
		record = Factory.build(:homex_outcome,options)
		record.save
		record
	end

	def create_complete_object(options={})
		s = Factory(:subject,options[:subject]||{})
		p = Project.find_or_create_by_code('HomeExposures')
		Factory(:enrollment, :subject => s, :project => p )
		h = create_object(
			(options[:homex_outcome]||{}).merge(:subject => s,
			:interview_outcome_on => nil,
			:sample_outcome_on => nil))
		h
	end

end

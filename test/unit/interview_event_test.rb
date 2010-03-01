require File.dirname(__FILE__) + '/../test_helper'

class InterviewEventTest < ActiveSupport::TestCase

	test "should create interview_event" do
		assert_difference 'InterviewEvent.count' do
			interview_event = create_interview_event
			assert !interview_event.new_record?, 
				"#{interview_event.errors.full_messages.to_sentence}"
		end
	end

#	test "should belong to a interview_type" do
#		interview_event = create_interview_event
#		assert_nil interview_event.interview_type
#		interview_event.interview_type = Factory(:interview_type)
#		assert_not_nil interview_event.interview_type
#	end

	test "should require address_id" do
		assert_no_difference 'InterviewEvent.count' do
			interview_event = create_interview_event(:address_id => nil)
			assert interview_event.errors.on(:address_id)
		end
	end

	test "should require subject_id" do
		assert_no_difference 'InterviewEvent.count' do
			interview_event = create_interview_event(:subject_id => nil)
			assert interview_event.errors.on(:subject_id)
		end
	end

	test "should require interviewer_id" do
		assert_no_difference 'InterviewEvent.count' do
			interview_event = create_interview_event(:interviewer_id => nil)
			assert interview_event.errors.on(:interviewer_id)
		end
	end

	test "should belong to an address" do
		interview_event = create_interview_event
#		assert_nil interview_event.address
#		interview_event.address = Factory(:address)
		assert_not_nil interview_event.address
	end

	test "should belong to a subject" do
		interview_event = create_interview_event
#		assert_nil interview_event.subject
#		interview_event.subject = Factory(:subject)
		assert_not_nil interview_event.subject
	end

	test "should belong to an interviewer" do
		interview_event = create_interview_event
#		assert_nil interview_event.interviewer
#		interview_event.interviewer = Factory(:interviewer)
		assert_not_nil interview_event.interviewer
	end

	test "should have many operational_event_types" do
		interview_event = create_interview_event
		assert_equal 0, interview_event.operational_event_types.length
		Factory(:operational_event_type, 
				:interview_event_id => interview_event.id)
		assert_equal 1, interview_event.reload.operational_event_types.length
		Factory(:operational_event_type, 
				:interview_event_id => interview_event.id)
		assert_equal 2, interview_event.reload.operational_event_types.length
	end

	test "should have many interview_versions" do
		interview_event = create_interview_event
		assert_equal 0, interview_event.interview_versions.length
		Factory(:interview_version, :interview_event_id => interview_event.id)
		assert_equal 1, interview_event.reload.interview_versions.length
		Factory(:interview_version, :interview_event_id => interview_event.id)
		assert_equal 2, interview_event.reload.interview_versions.length
	end

protected

	def create_interview_event(options = {})
		record = Factory.build(:interview_event,options)
		record.save
		record
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class InterviewTypeTest < ActiveSupport::TestCase

	test "should create interview_type" do
		assert_difference 'InterviewType.count' do
			interview_type = create_interview_type
			assert !interview_type.new_record?, "#{interview_type.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'InterviewType.count' do
			interview_type = create_interview_type(:description => nil)
			assert interview_type.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'InterviewType.count' do
			interview_type = create_interview_type(:description => 'Hey')
			assert interview_type.errors.on(:description)
		end
	end

	test "should belong to a study event" do
		interview_type = create_interview_type
		assert_nil interview_type.study_event
		interview_type.study_event = Factory(:study_event)
		assert_not_nil interview_type.study_event
	end

protected

	def create_interview_type(options = {})
		record = Factory.build(:interview_type,options)
		record.save
		record
	end

end

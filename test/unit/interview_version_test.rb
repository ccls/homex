require File.dirname(__FILE__) + '/../test_helper'

class InterviewVersionTest < ActiveSupport::TestCase

	test "should create interview_version" do
		assert_difference 'InterviewVersion.count' do
			interview_version = create_interview_version
			assert !interview_version.new_record?, "#{interview_version.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'InterviewVersion.count' do
			interview_version = create_interview_version(:description => nil)
			assert interview_version.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'InterviewVersion.count' do
			interview_version = create_interview_version(:description => 'Hey')
			assert interview_version.errors.on(:description)
		end
	end

	test "should belong to a interview_type" do
		interview_version = create_interview_version
		assert_nil interview_version.interview_type
		interview_version.interview_type = Factory(:interview_type)
		assert_not_nil interview_version.interview_type
	end

	test "should belong to a interview_event" do
		interview_version = create_interview_version
		assert_nil interview_version.interview_event
		interview_version.interview_event = Factory(:interview_event)
		assert_not_nil interview_version.interview_event
	end



protected

	def create_interview_version(options = {})
		record = Factory.build(:interview_version,options)
		record.save
		record
	end

end

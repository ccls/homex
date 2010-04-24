require File.dirname(__FILE__) + '/../test_helper'

class InterviewVersionTest < ActiveSupport::TestCase

	test "should create interview_version" do
		assert_difference 'InterviewVersion.count' do
			interview_version = create_interview_version
			assert !interview_version.new_record?, 
				"#{interview_version.errors.full_messages.to_sentence}"
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

	test "should require unique description" do
		iv = create_interview_version
		assert_no_difference 'InterviewVersion.count' do
			interview_version = create_interview_version(
				:description => iv.description)
			assert interview_version.errors.on(:description)
		end
	end

	test "should require valid interview_type_id" do
		assert_no_difference 'InterviewVersion.count' do
			interview_version = create_interview_version(
				:interview_type_id => 0)
			assert interview_version.errors.on(:interview_type)
		end
	end

	test "should require valid interview_event_id" do
		assert_no_difference 'InterviewVersion.count' do
			interview_version = create_interview_version(
				:interview_event_id => 0)
			assert interview_version.errors.on(:interview_event)
		end
	end

	test "should require interview_type_id" do
		assert_no_difference 'InterviewVersion.count' do
			interview_version = create_interview_version(
				:interview_type_id => nil)
			assert interview_version.errors.on(:interview_type)
		end
	end

	test "should require interview_event_id" do
		assert_no_difference 'InterviewVersion.count' do
			interview_version = create_interview_version(
				:interview_event_id => nil)
			assert interview_version.errors.on(:interview_event)
		end
	end

	test "should initially belong to a interview_type" do
		interview_version = create_interview_version
		assert_not_nil interview_version.interview_type
	end

	test "should initially belong to a interview_event" do
		interview_version = create_interview_version
		assert_not_nil interview_version.interview_event
	end

protected

	def create_interview_version(options = {})
		record = Factory.build(:interview_version,options)
		record.save
		record
	end

end

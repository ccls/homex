require File.dirname(__FILE__) + '/../test_helper'

class InterviewTypeTest < ActiveSupport::TestCase

	test "should create interview_type" do
		assert_difference 'InterviewType.count' do
			interview_type = create_interview_type
			assert !interview_type.new_record?, 
				"#{interview_type.errors.full_messages.to_sentence}"
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

	test "should require unique description" do
		it = create_interview_type
		assert_no_difference 'InterviewType.count' do
			interview_type = create_interview_type(
				:description => it.description)
			assert interview_type.errors.on(:description)
		end
	end

	test "should require study_event_id" do
		assert_no_difference 'InterviewType.count' do
			interview_type = create_interview_type(:study_event_id => nil)
			assert interview_type.errors.on(:study_event_id)
		end
	end

	test "should initially belong to a study event" do
		interview_type = create_interview_type
		assert_not_nil interview_type.study_event
	end

	test "should have many interview_versions" do
		interview_type = create_interview_type
		assert_equal 0, interview_type.interview_versions.length
		Factory(:interview_version, :interview_type_id => interview_type.id)
		assert_equal 1, interview_type.reload.interview_versions.length
		Factory(:interview_version, :interview_type_id => interview_type.id)
		assert_equal 2, interview_type.reload.interview_versions.length
	end

protected

	def create_interview_type(options = {})
		record = Factory.build(:interview_type,options)
		record.save
		record
	end

end

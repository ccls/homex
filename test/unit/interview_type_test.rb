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

protected

	def create_interview_type(options = {})
		record = Factory.build(:interview_type,options)
		record.save
		record
	end

end

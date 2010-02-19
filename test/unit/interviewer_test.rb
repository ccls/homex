require File.dirname(__FILE__) + '/../test_helper'

class InterviewerTest < ActiveSupport::TestCase


	test "should create interviewer" do
		assert_difference 'Interviewer.count' do
			interviewer = create_interviewer
			assert !interviewer.new_record?, "#{interviewer.errors.full_messages.to_sentence}"
		end
	end

#	test "should require description" do
#		assert_no_difference 'Interviewer.count' do
#			interviewer = create_interviewer(:description => nil)
#			assert interviewer.errors.on(:description)
#		end
#	end

	test "should belong to a context" do
		interviewer = create_interviewer
		assert_nil interviewer.context
		interviewer.context = Factory(:context)
		assert_not_nil interviewer.context
	end

protected

	def create_interviewer(options = {})
		record = Factory.build(:interviewer,options)
		record.save
		record
	end

end

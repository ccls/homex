require File.dirname(__FILE__) + '/../test_helper'

class InterviewTest < ActiveSupport::TestCase

	test "should create interview" do
		assert_difference 'Interview.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require address_id" do
		pending
#		assert_no_difference 'Interview.count' do
#			object = create_object(:address_id => nil)
#			assert object.errors.on(:address)
#		end
	end

	test "should require subject_id" do
		pending
#		assert_no_difference 'Interview.count' do
#			object = create_object(:subject_id => nil)
#			assert object.errors.on(:subject)
#		end
	end

	test "should require interviewer_id" do
		pending
#		assert_no_difference 'Interview.count' do
#			object = create_object(:interviewer_id => nil)
#			assert object.errors.on(:interviewer)
#		end
	end

	test "should require valid address_id" do
		pending
#		assert_no_difference 'Interview.count' do
#			object = create_object(:address_id => 0)
#			assert object.errors.on(:address)
#		end
	end

	test "should require valid subject_id" do
		pending
#		assert_no_difference 'Interview.count' do
#			object = create_object(:subject_id => 0)
#			assert object.errors.on(:subject)
#		end
	end

	test "should require valid interviewer_id" do
		pending
#		assert_no_difference 'Interview.count' do
#			object = create_object(:interviewer_id => 0)
#			assert object.errors.on(:interviewer)
#		end
	end

#	test "should initially belong to an address" do
	test "should belong to an address" do
		object = create_object
		assert_nil object.address
		object.address = Factory(:address)
		assert_not_nil object.address
	end

#	test "should initially belong to a subject" do
#		object = create_object
#		assert_not_nil object.subject
#	end

#	test "should initially belong to an interviewer" do
	test "should belong to an interviewer" do
		object = create_object
		assert_nil object.interviewer
		object.interviewer = Factory(:person)
		assert_not_nil object.interviewer
		assert object.interviewer.is_a?(Person)
	end

	test "should belong to an interview_version" do
		object = create_object
		assert_nil object.interview_version
		object.interview_version = Factory(:interview_version)
		assert_not_nil object.interview_version
	end

	test "should belong to an interview_method" do
		object = create_object
		assert_nil object.interview_method
		object.interview_method = Factory(:interview_method)
		assert_not_nil object.interview_method
	end

protected

	def create_object(options = {})
		record = Factory.build(:interview,options)
		record.save
		record
	end

end

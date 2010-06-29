require File.dirname(__FILE__) + '/../test_helper'

class InterviewVersionTest < ActiveSupport::TestCase

	test "should create interview_version" do
		assert_difference 'InterviewVersion.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require code" do
		assert_no_difference 'InterviewVersion.count' do
			object = create_object(:code => nil)
			assert object.errors.on(:code)
		end
	end

	test "should require unique code" do
		iv = create_object
		assert_no_difference 'InterviewVersion.count' do
			object = create_object(
				:code => iv.code)
			assert object.errors.on(:code)
		end
	end

	test "should require description" do
		assert_no_difference 'InterviewVersion.count' do
			object = create_object(:description => nil)
			assert object.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'InterviewVersion.count' do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should require unique description" do
		iv = create_object
		assert_no_difference 'InterviewVersion.count' do
			object = create_object(
				:description => iv.description)
			assert object.errors.on(:description)
		end
	end

	test "should require valid interview_type_id" do
		assert_no_difference 'InterviewVersion.count' do
			object = create_object(
				:interview_type_id => 0)
			assert object.errors.on(:interview_type)
		end
	end

	test "should require interview_type_id" do
		assert_no_difference 'InterviewVersion.count' do
			object = create_object(
				:interview_type_id => nil)
			assert object.errors.on(:interview_type)
		end
	end

	test "should initially belong to a interview_type" do
		object = create_object
		assert_not_nil object.interview_type
	end

	test "should belong to a language" do
		object = create_object
		assert_nil object.language
		object.language = Factory(:language)
		assert_not_nil object.language
	end

	test "should have many interviews" do
		object = create_object
		assert_equal 0, object.interviews.length
		Factory(:interview, :interview_version_id => object.id)
		assert_equal 1, object.reload.interviews.length
		Factory(:interview, :interview_version_id => object.id)
		assert_equal 2, object.reload.interviews.length
	end

	test "should act as list" do
		object = create_object
		assert_equal 1, object.position
		object = create_object
		assert_equal 2, object.position
	end

protected

	def create_object(options = {})
		record = Factory.build(:interview_version,options)
		record.save
		record
	end

end

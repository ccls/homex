require File.dirname(__FILE__) + '/../test_helper'

class InterviewMethodTest < ActiveSupport::TestCase

	test "should create interview_method" do
		assert_difference 'InterviewMethod.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require code" do
		assert_no_difference 'InterviewMethod.count' do
			object = create_object(
				:code => nil)
			assert object.errors.on(:code)
		end
	end

	test "should require unique code" do
		oet = create_object
		assert_no_difference 'InterviewMethod.count' do
			object = create_object(
				:code => oet.code)
			assert object.errors.on(:code)
		end
	end

	test "should require description" do
		assert_no_difference 'InterviewMethod.count' do
			object = create_object(
				:description => nil)
			assert object.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'InterviewMethod.count' do
			object = create_object(
				:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should require unique description" do
		oet = create_object
		assert_no_difference 'InterviewMethod.count' do
			object = create_object(
				:description => oet.description)
			assert object.errors.on(:description)
		end
	end

	test "should have many interviews" do
		object = create_object
		assert_equal 0, object.interviews.length
		Factory(:interview, :interview_method_id => object.id)
		assert_equal 1, object.reload.interviews.length
		Factory(:interview, :interview_method_id => object.id)
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
		record = Factory.build(:interview_method,options)
		record.save
		record
	end

end

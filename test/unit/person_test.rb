require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase

	assert_should_belong_to(:context)

	test "should create person" do
		assert_difference 'Person.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should have many interviews" do
		object = create_object
		assert_equal 0, object.interviews.length
		Factory(:interview, :interviewer_id => object.id)
		assert_equal 1, object.reload.interviews.length
		Factory(:interview, :interviewer_id => object.id)
		assert_equal 2, object.reload.interviews.length
	end

protected

	def create_object(options = {})
		record = Factory.build(:person,options)
		record.save
		record
	end

end

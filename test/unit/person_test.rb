require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase

	assert_should_belong_to(:context)
	assert_should_have_many(:interviews,
		:foreign_key => :interviewer_id )

	test "should create person" do
		assert_difference 'Person.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:person,options)
		record.save
		record
	end

end

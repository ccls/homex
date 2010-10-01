require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase

	assert_should_act_as_list
#	assert_should_belong_to(:context)
	assert_should_have_many(:organizations)
	assert_should_have_many(:interviews,
		:foreign_key => :interviewer_id )

	assert_should_require_attribute(:last_name)

	test "should create person" do
		assert_difference 'Person.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should return full_name as to_s" do
		object = create_object
		assert_equal object.full_name, "#{object}"
	end

	test "should find random" do
		object = Person.random()
		assert object.is_a?(Person)
	end

	test "should return nil on random when no records" do
		Person.stubs(:count).returns(0)
		object = Person.random()
		assert_nil object
	end

protected

	def create_object(options = {})
		record = Factory.build(:person,options)
		record.save
		record
	end

end

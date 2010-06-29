require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase

	test "should create person" do
		assert_difference 'Person.count' do
			person = create_person
			assert !person.new_record?, 
				"#{person.errors.full_messages.to_sentence}"
		end
	end

	test "should belong to a context" do
		person = create_person
		assert_nil person.context
		person.context = Factory(:context)
		assert_not_nil person.context
	end

	test "should have many interviews" do
		person = create_person
		assert_equal 0, person.interviews.length
		Factory(:interview, :interviewer_id => person.id)
		assert_equal 1, person.reload.interviews.length
		Factory(:interview, :interviewer_id => person.id)
		assert_equal 2, person.reload.interviews.length
	end

protected

	def create_person(options = {})
		record = Factory.build(:person,options)
		record.save
		record
	end

end

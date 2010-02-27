require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase


	test "should create person" do
		assert_difference 'Person.count' do
			person = create_person
			assert !person.new_record?, "#{person.errors.full_messages.to_sentence}"
		end
	end

#	test "should require description" do
#		assert_no_difference 'Person.count' do
#			person = create_person(:description => nil)
#			assert person.errors.on(:description)
#		end
#	end

	test "should belong to a context" do
		person = create_person
		assert_nil person.context
		person.context = Factory(:context)
		assert_not_nil person.context
	end

	test "should have many interview_events" do
		person = create_person
		assert_equal 0, person.interview_events.length
		person.interview_events << Factory(:interview_event)
		assert_equal 1, person.interview_events.length
		person.interview_events << Factory(:interview_event)
		assert_equal 2, person.reload.interview_events.length
	end

protected

	def create_person(options = {})
		record = Factory.build(:person,options)
		record.save
		record
	end

end

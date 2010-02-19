require File.dirname(__FILE__) + '/../test_helper'

class StudyEventTest < ActiveSupport::TestCase

	test "should create study_event" do
		assert_difference 'StudyEvent.count' do
			study_event = create_study_event
			assert !study_event.new_record?, "#{study_event.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'StudyEvent.count' do
			study_event = create_study_event(:description => nil)
			assert study_event.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'StudyEvent.count' do
			study_event = create_study_event(:description => 'Hey')
			assert study_event.errors.on(:description)
		end
	end

protected

	def create_study_event(options = {})
		record = Factory.build(:study_event,options)
		record.save
		record
	end

end

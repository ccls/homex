require File.dirname(__FILE__) + '/../test_helper'

class ContextTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:units,:people)
	assert_should_require(:code,:description)
	assert_should_require_unique(:code,:description)

	test "should create context" do
		assert_difference 'Context.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'Context.count' do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:context,options)
		record.save
		record
	end

end

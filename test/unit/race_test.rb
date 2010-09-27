require File.dirname(__FILE__) + '/../test_helper'

class RaceTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:subjects)
	assert_should_require(:code,:description)
	assert_should_require_unique(:code,:description)

	test "should create race" do
		assert_difference 'Race.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'Race.count' do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should return name as to_s" do
		object = create_object
		assert_equal object.name, "#{object}"
	end

	test "should find by code with []" do
		object = Race['1']
		assert object.is_a?(Race)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(Race::NotFound) {
#			object = Race['idonotexist']
#		}
#	end

protected

	def create_object(options = {})
		record = Factory.build(:race,options)
		record.save
		record
	end

end

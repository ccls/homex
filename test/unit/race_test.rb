require File.dirname(__FILE__) + '/../test_helper'

class RaceTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:subjects)

	test "should create race" do
		assert_difference 'Race.count' do
			race = create_race
			assert !race.new_record?, 
				"#{race.errors.full_messages.to_sentence}"
		end
	end

	test "should require name" do
		assert_no_difference 'Race.count' do
			race = create_race(:name => nil)
			assert race.errors.on(:name)
		end
	end

	test "should require 4 char name" do
		assert_no_difference 'Race.count' do
			race = create_race(:name => 'Hey')
			assert race.errors.on(:name)
		end
	end

	test "should require unique name" do
		race1 = create_race
		assert_no_difference 'Race.count' do
			race = create_race(:name => race1.name)
			assert race.errors.on(:name)
		end
	end

	test "should return name as to_s" do
		race = create_race
		assert_equal race.name, "#{race}"
	end

protected

	def create_race(options = {})
		record = Factory.build(:race,options)
		record.save
		record
	end
	alias_method :create_object, :create_race

end

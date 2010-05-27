require File.dirname(__FILE__) + '/../test_helper'

class RaceTest < ActiveSupport::TestCase

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

	test "should have many subjects" do
		race = create_race
		assert_equal 0, race.subjects.length
		Factory(:subject, :race_id => race.id)
		assert_equal 1, race.reload.subjects.length
		Factory(:subject, :race_id => race.id)
		assert_equal 2, race.reload.subjects.length
	end

	test "should return name as to_s" do
		race = create_race
		assert_equal race.name, "#{race}"
	end

	test "should act as list" do
		race = create_race
		assert_equal 1, race.position
		race = create_race
		assert_equal 2, race.position
	end

protected

	def create_race(options = {})
		record = Factory.build(:race,options)
		record.save
		record
	end

end

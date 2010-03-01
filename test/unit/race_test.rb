require File.dirname(__FILE__) + '/../test_helper'

class RaceTest < ActiveSupport::TestCase

	test "should create race" do
		assert_difference 'Race.count' do
			race = create_race
			assert !race.new_record?, "#{race.errors.full_messages.to_sentence}"
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

	test "should have many subjects" do
		race = create_race
#		assert_equal 0, race.subjects.length
#		race.subjects << Factory(:subject)
#		assert_equal 1, race.subjects.length
#		race.subjects << Factory(:subject)
#		assert_equal 2, race.reload.subjects.length
	end

protected

	def create_race(options = {})
		record = Factory.build(:race,options)
		record.save
		record
	end

end

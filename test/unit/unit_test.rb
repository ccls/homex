require File.dirname(__FILE__) + '/../test_helper'

class UnitTest < ActiveSupport::TestCase

	test "should create unit" do
		assert_difference 'Unit.count' do
			unit = create_unit
			assert !unit.new_record?, "#{unit.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'Unit.count' do
			unit = create_unit(:description => nil)
			assert unit.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'Unit.count' do
			unit = create_unit(:description => 'Hey')
			assert unit.errors.on(:description)
		end
	end

protected

	def create_unit(options = {})
		record = Factory.build(:unit,options)
		record.save
		record
	end

end

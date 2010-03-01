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

	test "should belong to a context" do
		unit = create_unit
		assert_nil unit.context
		unit.context = Factory(:context)
		assert_not_nil unit.context
	end

	test "should have many aliquots" do
		unit = create_unit
#		assert_equal 0, unit.aliquots.length
#		unit.aliquots << Factory(:aliquots)
#		assert_equal 1, unit.aliquots.length
#		unit.aliquots << Factory(:aliquots)
#		assert_equal 2, unit.reload.aliquots.length
	end

	test "should have many samples" do
		unit = create_unit
		assert_equal 0, unit.samples.length
		unit.samples << Factory(:sample)
		assert_equal 1, unit.samples.length
		unit.samples << Factory(:sample)
		assert_equal 2, unit.reload.samples.length
	end

protected

	def create_unit(options = {})
		record = Factory.build(:unit,options)
		record.save
		record
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class UnitTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:aliquots,:samples)

	test "should create unit" do
		assert_difference 'Unit.count' do
			unit = create_unit
			assert !unit.new_record?, 
				"#{unit.errors.full_messages.to_sentence}"
		end
	end

	test "should require code" do
		assert_no_difference 'Unit.count' do
			unit = create_unit(:code => nil)
			assert unit.errors.on(:code)
		end
	end

	test "should require unique code" do
		u = create_unit
		assert_no_difference 'Unit.count' do
			unit = create_unit(:code => u.code)
			assert unit.errors.on(:code)
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

	test "should require unique description" do
		u = create_unit
		assert_no_difference 'Unit.count' do
			unit = create_unit(:description => u.description)
			assert unit.errors.on(:description)
		end
	end

	test "should belong to a context" do
		unit = create_unit
		assert_nil unit.context
		unit.context = Factory(:context)
		assert_not_nil unit.context
	end

protected

	def create_unit(options = {})
		record = Factory.build(:unit,options)
		record.save
		record
	end
	alias_method :create_object, :create_unit

end

require File.dirname(__FILE__) + '/../test_helper'

class ContextTest < ActiveSupport::TestCase

	test "should create context" do
		assert_difference 'Context.count' do
			context = create_context
			assert !context.new_record?, "#{context.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'Context.count' do
			context = create_context(:description => nil)
			assert context.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'Context.count' do
			context = create_context(:description => 'Hey')
			assert context.errors.on(:description)
		end
	end

	test "should have many units" do
		context = create_context
		assert_equal 0, context.units.length
		context.units << Factory(:unit)
		assert_equal 1, context.units.length
		context.units << Factory(:unit)
		assert_equal 2, context.units.length
	end

	test "should have many people" do
		context = create_context
		assert_equal 0, context.people.length
		context.people << Factory(:person)
		assert_equal 1, context.people.length
		context.people << Factory(:person)
		assert_equal 2, context.people.length
	end

protected

	def create_context(options = {})
		record = Factory.build(:context,options)
		record.save
		record
	end

end

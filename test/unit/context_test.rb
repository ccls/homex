require File.dirname(__FILE__) + '/../test_helper'

class ContextTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:units,:people)

	test "should create context" do
		assert_difference 'Context.count' do
			context = create_context
			assert !context.new_record?, 
				"#{context.errors.full_messages.to_sentence}"
		end
	end

	test "should require code" do
		assert_no_difference 'Context.count' do
			context = create_context(:code => nil)
			assert context.errors.on(:code)
		end
	end

	test "should require unique code" do
		context = create_context
		assert_no_difference 'Context.count' do
			context = create_context(
				:code => context.code)
			assert context.errors.on(:code)
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

	test "should require unique description" do
		context = create_context
		assert_no_difference 'Context.count' do
			context = create_context(
				:description => context.description)
			assert context.errors.on(:description)
		end
	end

protected

	def create_context(options = {})
		record = Factory.build(:context,options)
		record.save
		record
	end
	alias_method :create_object, :create_context

end

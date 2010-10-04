require File.dirname(__FILE__) + '/../test_helper'

class SampleTypeTest < ActiveSupport::TestCase

	assert_should_act_as_list :scope => :parent_id
#	assert_should_have_many(:sample_subtypes)
	assert_should_have_many(:samples)
	assert_should_belong_to(:parent, 
#	assert_should_initially_belong_to(:parent, 
		:class_name => 'SampleType')
	assert_should_have_many(:children, 
		:class_name => 'SampleType',
		:foreign_key => 'parent_id')
#	assert_should_habtm(:sample_types)
	assert_should_require(:code,:description)
	assert_should_require_unique(:code,:description)

	test "should create sample_type" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require 4 char description" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should return description as to_s" do
		object = create_object(:description => "Description")
		assert_equal object.description,
			"#{object}"
	end

protected

	def create_object(options = {})
#		record = Factory.build(:sample_type,options)
#	The normal sample_type factory creates a parent 
#	which seems to cause some testing issues unless
#	this was expected so ....
		record = Factory.build(:sample_type_parent,options)
		record.save
		record
	end

end

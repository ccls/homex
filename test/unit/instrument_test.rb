require File.dirname(__FILE__) + '/../test_helper'

class InstrumentTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_belong_to(:interview_method)
	assert_should_initially_belong_to(:project)
	assert_should_require(:code,:name)
	assert_should_require_unique(:code,:description)

	test "should create instrument" do
		assert_difference 'Instrument.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'Instrument.count' do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	#	unfortunately name is NOT unique so should change this
	test "should return name as to_s" do
		object = create_object
		assert_equal object.name, "#{object}"
	end

protected

	def create_object(options = {})
		record = Factory.build(:instrument,options)
		record.save
		record
	end

end

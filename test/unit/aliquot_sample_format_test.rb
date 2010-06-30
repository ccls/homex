require File.dirname(__FILE__) + '/../test_helper'

class AliquotSampleFormatTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:aliquots,:samples)
	assert_should_require(:code,:description)
	assert_should_require_unique(:code,:description)

	test "should create aliquot_sample_format" do
		assert_difference 'AliquotSampleFormat.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'AliquotSampleFormat.count' do
			object = create_object(
				:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:aliquot_sample_format,options)
		record.save
		record
	end

end

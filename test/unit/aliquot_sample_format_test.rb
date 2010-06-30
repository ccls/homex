require File.dirname(__FILE__) + '/../test_helper'

class AliquotSampleFormatTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:aliquots,:samples)

	test "should create aliquot_sample_format" do
		assert_difference 'AliquotSampleFormat.count' do
			aliquot_sample_format = create_aliquot_sample_format
			assert !aliquot_sample_format.new_record?, 
				"#{aliquot_sample_format.errors.full_messages.to_sentence}"
		end
	end

	test "should require code" do
		assert_no_difference 'AliquotSampleFormat.count' do
			aliquot_sample_format = create_aliquot_sample_format(
				:code => nil)
			assert aliquot_sample_format.errors.on(:code)
		end
	end

	test "should require unique code" do
		asf = create_aliquot_sample_format
		assert_no_difference 'AliquotSampleFormat.count' do
			aliquot_sample_format = create_aliquot_sample_format(
				:code => asf.code)
			assert aliquot_sample_format.errors.on(:code)
		end
	end

	test "should require description" do
		assert_no_difference 'AliquotSampleFormat.count' do
			aliquot_sample_format = create_aliquot_sample_format(
				:description => nil)
			assert aliquot_sample_format.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'AliquotSampleFormat.count' do
			aliquot_sample_format = create_aliquot_sample_format(
				:description => 'Hey')
			assert aliquot_sample_format.errors.on(:description)
		end
	end

	test "should require unique description" do
		asf = create_aliquot_sample_format
		assert_no_difference 'AliquotSampleFormat.count' do
			aliquot_sample_format = create_aliquot_sample_format(
				:description => asf.description)
			assert aliquot_sample_format.errors.on(:description)
		end
	end

protected

	def create_aliquot_sample_format(options = {})
		record = Factory.build(:aliquot_sample_format,options)
		record.save
		record
	end
	alias_method :create_object, :create_aliquot_sample_format

end

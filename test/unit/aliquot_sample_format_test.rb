require File.dirname(__FILE__) + '/../test_helper'

class AliquotSampleFormatTest < ActiveSupport::TestCase

	test "should create aliquot_sample_format" do
		assert_difference 'AliquotSampleFormat.count' do
			aliquot_sample_format = create_aliquot_sample_format
			assert !aliquot_sample_format.new_record?, "#{aliquot_sample_format.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'AliquotSampleFormat.count' do
			aliquot_sample_format = create_aliquot_sample_format(:description => nil)
			assert aliquot_sample_format.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'AliquotSampleFormat.count' do
			aliquot_sample_format = create_aliquot_sample_format(:description => 'Hey')
			assert aliquot_sample_format.errors.on(:description)
		end
	end


	test "should have many aliquots" do

#		flunk aliquots

	end

	test "should have many samples" do

#		flunk samples

	end

protected

	def create_aliquot_sample_format(options = {})
		record = Factory.build(:aliquot_sample_format,options)
		record.save
		record
	end

end

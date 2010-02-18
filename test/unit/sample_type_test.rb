require File.dirname(__FILE__) + '/../test_helper'

class SampleTypeTest < ActiveSupport::TestCase

	test "should create sample_type" do
		assert_difference 'SampleType.count' do
			sample_type = create_sample_type
			assert !sample_type.new_record?, "#{sample_type.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'SampleType.count' do
			sample_type = create_sample_type(:description => nil)
			assert sample_type.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'SampleType.count' do
			sample_type = create_sample_type(:description => 'Hey')
			assert sample_type.errors.on(:description)
		end
	end

protected

	def create_sample_type(options = {})
		record = Factory.build(:sample_type,options)
		record.save
		record
	end

end

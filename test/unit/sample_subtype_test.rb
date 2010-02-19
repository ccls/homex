require File.dirname(__FILE__) + '/../test_helper'

class SampleSubtypeTest < ActiveSupport::TestCase

	test "should create sample_subtype" do
		assert_difference 'SampleSubtype.count' do
			sample_subtype = create_sample_subtype
			assert !sample_subtype.new_record?, "#{sample_subtype.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'SampleSubtype.count' do
			sample_subtype = create_sample_subtype(:description => nil)
			assert sample_subtype.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'SampleSubtype.count' do
			sample_subtype = create_sample_subtype(:description => 'Hey')
			assert sample_subtype.errors.on(:description)
		end
	end

	test "should belong to sample_type" do
		sample_subtype = create_sample_subtype
		assert_nil sample_subtype.sample_type
		sample_subtype.sample_type = Factory(:sample_type)
		assert_not_nil sample_subtype.sample_type
	end

protected

	def create_sample_subtype(options = {})
		record = Factory.build(:sample_subtype,options)
		record.save
		record
	end

end

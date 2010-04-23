require File.dirname(__FILE__) + '/../test_helper'

class SampleSubtypeTest < ActiveSupport::TestCase

	test "should create sample_subtype" do
		assert_difference 'SampleSubtype.count' do
			sample_subtype = create_sample_subtype
			assert !sample_subtype.new_record?, 
				"#{sample_subtype.errors.full_messages.to_sentence}"
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

	test "should require unique description" do
		sst = create_sample_subtype
		assert_no_difference 'SampleSubtype.count' do
			sample_subtype = create_sample_subtype(
				:description => sst.description)
			assert sample_subtype.errors.on(:description)
		end
	end

	test "should require valid sample_type_id" do
		assert_no_difference 'SampleSubtype.count' do
			sample_subtype = create_sample_subtype(:sample_type_id => 0)
			assert sample_subtype.errors.on(:sample_type_id)
		end
	end

	test "should require sample_type_id" do
		assert_no_difference 'SampleSubtype.count' do
			sample_subtype = create_sample_subtype(:sample_type_id => nil)
			assert sample_subtype.errors.on(:sample_type_id)
		end
	end

	test "should initially belong to sample_type" do
		sample_subtype = create_sample_subtype
		assert_not_nil sample_subtype.sample_type
	end

	test "should have many samples" do
		sample_subtype = create_sample_subtype
		assert_equal 0, sample_subtype.samples.length
		sample_subtype.samples << Factory(:sample)
		assert_equal 1, sample_subtype.samples.length
		sample_subtype.samples << Factory(:sample)
		assert_equal 2, sample_subtype.reload.samples.length
	end

protected

	def create_sample_subtype(options = {})
		record = Factory.build(:sample_subtype,options)
		record.save
		record
	end

end

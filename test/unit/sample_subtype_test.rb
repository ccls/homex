require File.dirname(__FILE__) + '/../test_helper'

class SampleSubtypeTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:samples)
	assert_requires_valid_associations(:sample_type)

	test "should create sample_subtype" do
		assert_difference 'SampleSubtype.count' do
			sample_subtype = create_sample_subtype
			assert !sample_subtype.new_record?, 
				"#{sample_subtype.errors.full_messages.to_sentence}"
		end
	end

	test "should require code" do
		assert_no_difference 'SampleSubtype.count' do
			sample_subtype = create_sample_subtype(:code => nil)
			assert sample_subtype.errors.on(:code)
		end
	end

	test "should require unique code" do
		sst = create_sample_subtype
		assert_no_difference 'SampleSubtype.count' do
			sample_subtype = create_sample_subtype(
				:code => sst.code)
			assert sample_subtype.errors.on(:code)
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

	test "should initially belong to sample_type" do
		sample_subtype = create_sample_subtype
		assert_not_nil sample_subtype.sample_type
	end

protected

	def create_sample_subtype(options = {})
		record = Factory.build(:sample_subtype,options)
		record.save
		record
	end
	alias_method :create_object, :create_sample_subtype

end

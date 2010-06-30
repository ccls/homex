require File.dirname(__FILE__) + '/../test_helper'

class SampleTypeTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:sample_subtypes)

	test "should create sample_type" do
		assert_difference 'SampleType.count' do
			sample_type = create_sample_type
			assert !sample_type.new_record?, 
				"#{sample_type.errors.full_messages.to_sentence}"
		end
	end

	test "should require code" do
		assert_no_difference 'SampleType.count' do
			sample_type = create_sample_type(:code => nil)
			assert sample_type.errors.on(:code)
		end
	end

	test "should require unique code" do
		st = create_sample_type
		assert_no_difference 'SampleType.count' do
			sample_type = create_sample_type(
				:code => st.code)
			assert sample_type.errors.on(:code)
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

	test "should require unique description" do
		st = create_sample_type
		assert_no_difference 'SampleType.count' do
			sample_type = create_sample_type(
				:description => st.description)
			assert sample_type.errors.on(:description)
		end
	end

protected

	def create_sample_type(options = {})
		record = Factory.build(:sample_type,options)
		record.save
		record
	end
	alias_method :create_object, :create_sample_type

end

require File.dirname(__FILE__) + '/../test_helper'

class SampleTypeTest < ActiveSupport::TestCase

	test "should create sample_type" do
		assert_difference 'SampleType.count' do
			sample_type = create_sample_type
			assert !sample_type.new_record?, 
				"#{sample_type.errors.full_messages.to_sentence}"
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

	test "should have many sample_subtypes" do
		sample_type = create_sample_type
		assert_equal 0, sample_type.sample_subtypes.length
		Factory(:sample_subtype, :sample_type_id => sample_type.id)
		assert_equal 1, sample_type.reload.sample_subtypes.length
		Factory(:sample_subtype, :sample_type_id => sample_type.id)
		assert_equal 2, sample_type.reload.sample_subtypes.length
	end

	test "should act as list" do
		sample_type = create_sample_type
		assert_equal 1, sample_type.position
		sample_type = create_sample_type
		assert_equal 2, sample_type.position
	end

protected

	def create_sample_type(options = {})
		record = Factory.build(:sample_type,options)
		record.save
		record
	end

end

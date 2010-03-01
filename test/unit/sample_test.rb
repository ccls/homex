require File.dirname(__FILE__) + '/../test_helper'

class SampleTest < ActiveSupport::TestCase

	test "should create sample" do
		assert_difference 'Sample.count' do
			sample = create_sample
			assert !sample.new_record?, "#{sample.errors.full_messages.to_sentence}"
		end
	end

	test "should belong to aliquot_sample_format" do
		sample = create_sample
		assert_nil sample.aliquot_sample_format
		sample.aliquot_sample_format = Factory(:aliquot_sample_format)
		assert_not_nil sample.aliquot_sample_format
	end

	test "should belong to sample_subtype" do
		sample = create_sample
		assert_nil sample.sample_subtype
		sample.sample_subtype = Factory(:sample_subtype)
		assert_not_nil sample.sample_subtype
	end

	test "should belong to subject" do
		sample = create_sample
		assert_nil sample.subject
		sample.subject = Factory(:subject)
		assert_not_nil sample.subject
	end

	test "should belong to unit" do
		sample = create_sample
		assert_nil sample.unit
		sample.unit = Factory(:unit)
		assert_not_nil sample.unit
	end

#	somehow

#	test "should belong to organization" do
#		sample = create_sample
#		assert_nil sample.organization
#		sample.organization = Factory(:organization)
#		assert_not_nil sample.organization
#	end

	test "should have many aliquots" do
		sample = create_sample
#		assert_equal 0, sample.aliquots.length
#		sample.aliquots << Factory(:aliquot)
#		assert_equal 1, sample.aliquots.length
#		sample.aliquots << Factory(:aliquot)
#		assert_equal 2, sample.reload.aliquots.length
	end


protected

	def create_sample(options = {})
		record = Factory.build(:sample,options)
		record.save
		record
	end

end

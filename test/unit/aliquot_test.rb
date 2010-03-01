require File.dirname(__FILE__) + '/../test_helper'

class AliquotTest < ActiveSupport::TestCase

	test "should create aliquot" do
		assert_difference 'Aliquot.count' do
			aliquot = create_aliquot
			assert !aliquot.new_record?, "#{aliquot.errors.full_messages.to_sentence}"
		end
	end

#	test "should require description" do
#		assert_no_difference 'Aliquot.count' do
#			aliquot = create_aliquot(:description => nil)
#			assert aliquot.errors.on(:description)
#		end
#	end

	test "should belong to aliquot_sample_format" do
		aliquot = create_aliquot
		assert_nil aliquot.aliquot_sample_format
		aliquot.aliquot_sample_format = Factory(:aliquot_sample_format)
		assert_not_nil aliquot.aliquot_sample_format
	end

	test "should belong to sample" do
		aliquot = create_aliquot
		assert_nil aliquot.sample
		aliquot.sample = Factory(:sample)
		assert_not_nil aliquot.sample
	end

	test "should belong to unit" do
		aliquot = create_aliquot
		assert_nil aliquot.unit
		aliquot.unit = Factory(:unit)
		assert_not_nil aliquot.unit
	end

	test "should have many transfers" do
		aliquot = create_aliquot
		assert_equal 0, aliquot.transfers.length
		Factory(:transfer, :aliquot_id => aliquot.id)
		assert_equal 1, aliquot.reload.transfers.length
		Factory(:transfer, :aliquot_id => aliquot.id)
		assert_equal 2, aliquot.reload.transfers.length
	end


protected

	def create_aliquot(options = {})
		record = Factory.build(:aliquot,options)
		record.save
		record
	end

end

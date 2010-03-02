require File.dirname(__FILE__) + '/../test_helper'

class AliquotTest < ActiveSupport::TestCase

	test "should create aliquot" do
		assert_difference 'Aliquot.count' do
			aliquot = create_aliquot
			assert !aliquot.new_record?, 
				"#{aliquot.errors.full_messages.to_sentence}"
		end
	end

	test "should require sample_id" do
		assert_no_difference 'Aliquot.count' do
			aliquot = create_aliquot(:sample_id => nil)
			assert aliquot.errors.on(:sample_id)
		end
	end

	test "should require unit_id" do
		assert_no_difference 'Aliquot.count' do
			aliquot = create_aliquot(:unit_id => nil)
			assert aliquot.errors.on(:unit_id)
		end
	end

	test "should require owner_id" do
		assert_no_difference 'Aliquot.count' do
			aliquot = create_aliquot(:owner_id => nil)
			assert aliquot.errors.on(:owner_id)
		end
	end

	test "should belong to aliquot_sample_format" do
		aliquot = create_aliquot
		assert_nil aliquot.aliquot_sample_format
		aliquot.aliquot_sample_format = Factory(:aliquot_sample_format)
		assert_not_nil aliquot.aliquot_sample_format
	end

	test "should belong to sample" do
		aliquot = create_aliquot
#		assert_nil aliquot.sample
#		aliquot.sample = Factory(:sample)
		assert_not_nil aliquot.sample
	end

	test "should belong to unit" do
		aliquot = create_aliquot
#		assert_nil aliquot.unit
#		aliquot.unit = Factory(:unit)
		assert_not_nil aliquot.unit
	end

	test "should belong to owner" do
		aliquot = create_aliquot
#		assert_nil aliquot.owner
#		aliquot.unit = Factory(:owner
		assert_not_nil aliquot.owner
		assert aliquot.owner.is_a?(Organization)
	end

	test "should have many transfers" do
		aliquot = create_aliquot
		assert_equal 0, aliquot.transfers.length
		Factory(:transfer, :aliquot_id => aliquot.id)
		assert_equal 1, aliquot.reload.transfers.length
		Factory(:transfer, :aliquot_id => aliquot.id)
		assert_equal 2, aliquot.reload.transfers.length
	end

	test "should transfer to another organization" do
		aliquot = create_aliquot
		initial_owner = aliquot.owner
		assert_not_nil initial_owner
		new_owner = Factory(:organization)
		assert_difference('aliquot.reload.owner_id') {
		assert_difference('aliquot.transfers.count', 1) {
		assert_difference('initial_owner.aliquots.count', -1) {
		assert_difference('new_owner.aliquots.count', 1) {
		assert_difference('Transfer.count',1) {
			aliquot.transfer_to(new_owner)
		} } } } }
		assert_not_nil aliquot.reload.owner
	end

protected

	def create_aliquot(options = {})
		record = Factory.build(:aliquot,options)
		record.save
		record
	end

end

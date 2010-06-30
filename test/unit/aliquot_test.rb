require File.dirname(__FILE__) + '/../test_helper'

class AliquotTest < ActiveSupport::TestCase

	assert_should_have_many(:transfers)
	assert_requires_valid_associations(:sample,:unit,:owner)

	test "should create aliquot" do
		assert_difference 'Aliquot.count' do
			aliquot = create_aliquot
			assert !aliquot.new_record?, 
				"#{aliquot.errors.full_messages.to_sentence}"
		end
	end

	test "should belong to aliquot_sample_format" do
		aliquot = create_aliquot
		assert_nil aliquot.aliquot_sample_format
		aliquot.aliquot_sample_format = Factory(:aliquot_sample_format)
		assert_not_nil aliquot.aliquot_sample_format
	end

	test "should initially belong to sample" do
		aliquot = create_aliquot
		assert_not_nil aliquot.sample
	end

	test "should initially belong to unit" do
		aliquot = create_aliquot
		assert_not_nil aliquot.unit
	end

	test "should belong to owner" do
		aliquot = create_aliquot
		assert_not_nil aliquot.owner
		assert aliquot.owner.is_a?(Organization)
	end

	test "should transfer to another organization" do
		aliquot = create_aliquot
		initial_owner = aliquot.owner
		assert_not_nil initial_owner
		new_owner = Factory(:organization)
		assert_difference('aliquot.reload.owner_id') {
		assert_difference('aliquot.transfers.count', 1) {
		assert_difference('initial_owner.reload.aliquots_count', -1) {
		assert_difference('initial_owner.aliquots.count', -1) {
		assert_difference('new_owner.reload.aliquots_count', 1) {
		assert_difference('new_owner.aliquots.count', 1) {
		assert_difference('Transfer.count',1) {
			aliquot.transfer_to(new_owner)
		} } } } } } }
		assert_not_nil aliquot.reload.owner
	end

	test "should NOT transfer if aliquot owner update fails" do
		aliquot = create_aliquot
		initial_owner = aliquot.owner
		assert_not_nil initial_owner
		new_owner = Factory(:organization)
		Aliquot.any_instance.stubs(:update_attribute).returns(false)
		assert_no_difference('aliquot.reload.owner_id') {
		assert_no_difference('aliquot.transfers.count') {
		assert_no_difference('initial_owner.aliquots.count') {
		assert_no_difference('initial_owner.aliquots_count') {
		assert_no_difference('new_owner.aliquots.count') {
		assert_no_difference('new_owner.aliquots_count') {
		assert_no_difference('Transfer.count') {
		assert_raise(ActiveRecord::RecordNotSaved){
			aliquot.transfer_to(new_owner)
		} } } } } } } }
		assert_not_nil aliquot.reload.owner
	end

	test "should NOT transfer if transfer creation fails" do
		aliquot = create_aliquot
		initial_owner = aliquot.owner
		assert_not_nil initial_owner
		new_owner = Factory(:organization)
		Transfer.any_instance.stubs(:save!).raises(
			ActiveRecord::RecordInvalid.new(Transfer.new))
		assert_no_difference('aliquot.reload.owner_id') {
		assert_no_difference('aliquot.transfers.count') {
		assert_no_difference('initial_owner.aliquots.count') {
		assert_no_difference('initial_owner.aliquots_count') {
		assert_no_difference('new_owner.aliquots.count') {
		assert_no_difference('new_owner.aliquots_count') {
		assert_no_difference('Transfer.count') {
		assert_raise(ActiveRecord::RecordInvalid){
			aliquot.transfer_to(new_owner)
		} } } } } } } }
		assert_not_nil aliquot.reload.owner
	end

	test "should NOT transfer to invalid organization" do
		aliquot = create_aliquot
		initial_owner = aliquot.owner
		assert_not_nil initial_owner
		assert_no_difference('aliquot.reload.owner_id') {
		assert_no_difference('aliquot.transfers.count') {
		assert_no_difference('initial_owner.aliquots_count') {
		assert_no_difference('initial_owner.aliquots.count') {
		assert_no_difference('Transfer.count') {
		assert_raise(ActiveRecord::RecordNotFound){
			aliquot.transfer_to(0)
		} } } } } }
		assert_not_nil aliquot.reload.owner
	end

protected

	def create_aliquot(options = {})
		record = Factory.build(:aliquot,options)
		record.save
		record
	end
	alias_method :create_object, :create_aliquot

end

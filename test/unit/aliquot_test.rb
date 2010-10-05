require File.dirname(__FILE__) + '/../test_helper'

class AliquotTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_many(:transfers)
	assert_requires_valid_associations(:sample,:unit)
	assert_requires_valid_associations(:organization, :as => :owner)
	assert_should_belong_to(:aliquot_sample_format)
	assert_should_initially_belong_to(:sample,:unit)
	assert_should_initially_belong_to(:owner,:class_name => 'Organization')

#	test "should create aliquot" do
#		assert_difference( "#{model_name}.count", 1 ) do
#			object = create_object
#			assert !object.new_record?, 
#				"#{object.errors.full_messages.to_sentence}"
#		end
#	end

	test "should transfer to another organization" do
		object = create_object
		initial_owner = object.owner
		assert_not_nil initial_owner
		new_owner = Factory(:organization)
		assert_difference('object.reload.owner_id') {
		assert_difference('object.transfers.count', 1) {
#		assert_difference('initial_owner.reload.aliquots_count', -1) {
		assert_difference('initial_owner.aliquots.count', -1) {
#		assert_difference('new_owner.reload.aliquots_count', 1) {
		assert_difference('new_owner.aliquots.count', 1) {
		assert_difference('Transfer.count',1) {
			object.transfer_to(new_owner)
		} } } } } #} }
		assert_not_nil object.reload.owner
	end

	test "should NOT transfer if aliquot owner update fails" do
		object = create_object
		initial_owner = object.owner
		assert_not_nil initial_owner
		new_owner = Factory(:organization)
		Aliquot.any_instance.stubs(:update_attribute).returns(false)
		assert_no_difference('object.reload.owner_id') {
		assert_no_difference('object.transfers.count') {
		assert_no_difference('initial_owner.aliquots.count') {
#		assert_no_difference('initial_owner.aliquots_count') {
		assert_no_difference('new_owner.aliquots.count') {
#		assert_no_difference('new_owner.aliquots_count') {
		assert_no_difference('Transfer.count') {
		assert_raise(ActiveRecord::RecordNotSaved){
			object.transfer_to(new_owner)
		} } } } } } #} }
		assert_not_nil object.reload.owner
	end

	test "should NOT transfer if transfer creation fails" do
		object = create_object
		initial_owner = object.owner
		assert_not_nil initial_owner
		new_owner = Factory(:organization)
		Transfer.any_instance.stubs(:save!).raises(
			ActiveRecord::RecordInvalid.new(Transfer.new))
		assert_no_difference('object.reload.owner_id') {
		assert_no_difference('object.transfers.count') {
		assert_no_difference('initial_owner.aliquots.count') {
#		assert_no_difference('initial_owner.aliquots_count') {
		assert_no_difference('new_owner.aliquots.count') {
#		assert_no_difference('new_owner.aliquots_count') {
		assert_no_difference('Transfer.count') {
		assert_raise(ActiveRecord::RecordInvalid){
			object.transfer_to(new_owner)
		} } } } } } #} }
		assert_not_nil object.reload.owner
	end

	test "should NOT transfer to invalid organization" do
		object = create_object
		initial_owner = object.owner
		assert_not_nil initial_owner
		assert_no_difference('object.reload.owner_id') {
		assert_no_difference('object.transfers.count') {
#		assert_no_difference('initial_owner.aliquots_count') {
		assert_no_difference('initial_owner.aliquots.count') {
		assert_no_difference('Transfer.count') {
		assert_raise(ActiveRecord::RecordNotFound){
			object.transfer_to(0)
		} } } } } #}
		assert_not_nil object.reload.owner
	end

end

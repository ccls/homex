require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < ActiveSupport::TestCase

	test "should create address" do
		assert_difference 'Address.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should NOT destroy residence on destroy" do
		object = create_object
		Factory(:residence, :address_id => object.id)
		assert_difference('Residence.count',0) {
		assert_difference('Address.count',-1) {
			object.destroy
		} }
	end

	test "should have many interviews" do
		object = create_object
		assert_equal 0, object.interviews.length
		Factory(:interview, :address_id => object.id)
		assert_equal 1, object.reload.interviews.length
		Factory(:interview, :address_id => object.id)
		assert_equal 2, object.reload.interviews.length
	end

	test "should have one residence" do
		object = create_object
		assert_nil object.residence
		Factory(:residence, :address_id => object.id)
		assert_not_nil object.reload.residence
	end

	test "should belong to subject" do
		object = create_object
		assert_nil object.subject
		object.subject = Factory(:subject)
		assert_not_nil object.subject
	end

	test "should belong to address_type" do
		object = create_object
		assert_nil object.address_type
		object.address_type = Factory(:address_type)
		assert_not_nil object.address_type
	end

	test "should belong to data_source" do
		object = create_object
		assert_nil object.data_source
		object.data_source = Factory(:data_source)
		assert_not_nil object.data_source
	end

protected

	def create_object(options = {})
		record = Factory.build(:address,options)
		record.save
		record
	end

end

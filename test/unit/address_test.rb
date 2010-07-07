require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:subject)
	assert_should_have_one(:residence)
	assert_should_have_many(:interviews)
	assert_should_belong_to(:address_type,:data_source)
	assert_should_initially_belong_to(:subject)

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

protected

	def create_object(options = {})
		record = Factory.build(:address,options)
		record.save
		record
	end

end

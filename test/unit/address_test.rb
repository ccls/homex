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

	test "should order address chronologically reversed" do
		a1 = Factory(:address, :created_at => Date.jd(2440000) ).id
		a2 = Factory(:address, :created_at => Date.jd(2450000) ).id
		a3 = Factory(:address, :created_at => Date.jd(2445000) ).id
		address_ids = Address.all.collect(&:id)
		assert_equal address_ids, [a2,a3,a1]
	end

	test "should return city state and zip with csz" do
		address = Factory(:address,
			:city => 'City',
			:state => 'CA',
			:zip   => '12345')
		assert_equal "City, CA 12345", address.csz
	end

protected

	def create_object(options = {})
		record = Factory.build(:address,options)
		record.save
		record
	end

end

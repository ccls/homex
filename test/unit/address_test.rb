require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:subject,:address_type)
	assert_should_have_one(:residence)
	assert_should_have_many(:interviews)
	assert_should_belong_to(:data_source)
	assert_should_initially_belong_to(:subject,:address_type)

	test "should create address" do
		assert_difference 'Address.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require line_1" do
		assert_difference('Address.count',0) do
			object = create_object( :line_1 => nil )
			assert object.errors.on(:line_1)
		end
	end

	test "should require city" do
		assert_difference('Address.count',0) do
			object = create_object( :city => nil )
			assert object.errors.on(:city)
		end
	end

	test "should require state" do
		assert_difference('Address.count',0) do
			object = create_object( :state => nil )
			assert object.errors.on(:state)
		end
	end

	test "should require zip" do
		assert_difference('Address.count',0) do
			object = create_object( :zip => nil )
			assert object.errors.on(:zip)
		end
	end

	test "should require 5 or 9 digit zip" do
		%w( asdf 1234 123456 1234Q ).each do |bad_zip|
			assert_difference('Address.count',0) do
				object = create_object( :zip => bad_zip )
				assert object.errors.on(:zip)
			end
		end
		%w( 12345 12345-6789 123456789 ).each do |good_zip|
			assert_difference('Address.count',1) do
				object = create_object( :zip => good_zip )
				assert !object.errors.on(:zip)
			end
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

	test "should require non-residence address type with pobox in line" do
		assert_difference('Address.count',0) do
			object = create_object({
				:line_1 => "P.O. Box 123",
				:address_type_id => AddressType.find_by_code('residence').id
			})
			assert object.errors.on(:address_type_id)
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:address,options)
		record.save
		record
	end

end

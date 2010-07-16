require File.dirname(__FILE__) + '/../test_helper'

class SampleKitTest < ActiveSupport::TestCase

	assert_should_belong_to(:sample,:sample_package,:kit_package)

	test "should create sample kit" do
		assert_difference 'SampleKit.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should create sample kit with kit package" do
		assert_difference('SampleKit.count', 1) {
		assert_difference('Package.count', 1) {
			object = create_object(
				:kit_package_attributes => Factory.attributes_for(:package) )
		} }
	end

	test "should create sample kit with sample package" do
		assert_difference('SampleKit.count', 1) {
		assert_difference('Package.count', 1) {
			object = create_object(
				:sample_package_attributes => Factory.attributes_for(:package) )
		} }
	end

	test "should create sample kit with both packages" do
		assert_difference('SampleKit.count', 1) {
		assert_difference('Package.count', 2) {
			object = create_object(
				:kit_package_attributes  => Factory.attributes_for(:package),
				:sample_package_attributes => Factory.attributes_for(:package) 
			)
		} }
	end

	test "should require a unique sample" do
		assert_difference('SampleKit.count', 2) {
#		assert_difference('Subject.count', 1) {
		assert_difference('Sample.count', 1) {
			object = create_object
			assert_nil object.sample
			sample = Factory(:sample)
			object.update_attributes(:sample_id => sample.id)
			assert_not_nil object.sample
			object = create_object
			assert_nil object.sample
			object.update_attributes(:sample_id => sample.id)
			assert object.reload.errors.on(:sample_id)
		} }
	end

	test "should returned status New" do
		object = create_complete_sample_kit	
		assert_equal 'New', object.status
	end

	test "should returned status Shipped" do
		object = create_complete_sample_kit	
		object.kit_package.update_attribute(:status,'Transit')
		assert_equal 'Shipped', object.status
	end

	test "should returned status Delivered" do
		object = create_complete_sample_kit	
		object.kit_package.update_attribute(:status,'Delivered')
		assert_equal 'Delivered', object.status
	end

	test "should returned status Returned" do
		object = create_complete_sample_kit	
		object.sample_package.update_attribute(:status,'Transit')
		assert_equal 'Returned', object.status
	end

	test "should returned status Received" do
		object = create_complete_sample_kit	
		object.sample_package.update_attribute(:status,'Delivered')
		assert_equal 'Received', object.status
	end

	test "should return null sent_on with new kit" do
		object = create_complete_sample_kit	
		assert_nil object.sent_on
	end

	test "should return null received_on with new kit" do
		object = create_complete_sample_kit	
		assert_nil object.received_on
	end

	test "should return date sent_on with kit in transit" do
		stub_package_for_in_transit()
		object = create_complete_sample_kit	
		object.kit_package.update_status
		assert_not_nil object.sent_on
	end

	test "should return null received_on with kit in transit" do
		stub_package_for_in_transit()
		object = create_complete_sample_kit	
		object.kit_package.update_status
		assert_nil object.received_on
	end

	test "should return date sent_on with kit returned" do
		stub_package_for_successful_delivery()
		object = create_complete_sample_kit	
		object.kit_package.update_status
		object.sample_package.update_status
		assert_not_nil object.sent_on
	end

	test "should return date received_on with kit returned" do
		stub_package_for_successful_delivery()
		object = create_complete_sample_kit	
		object.sample_package.update_status
		assert_not_nil object.received_on
	end

protected

	def create_complete_sample_kit(options={})
		object = create_object(
			:kit_package_attributes  => Factory.attributes_for(:package),
			:sample_package_attributes => Factory.attributes_for(:package) 
		)
	end

	def create_object(options = {})
		record = Factory.build(:sample_kit,options)
		record.save
		record
	end

end
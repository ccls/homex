require File.dirname(__FILE__) + '/../test_helper'

class DustKitTest < ActiveSupport::TestCase

	assert_should_belong_to(:subject,:dust_package,:kit_package)

	test "should create dust_kit" do
		assert_difference 'DustKit.count' do
			dust_kit = create_dust_kit
			assert !dust_kit.new_record?, 
				"#{dust_kit.errors.full_messages.to_sentence}"
		end
	end

	test "should create dust_kit with kit_package" do
		assert_difference('DustKit.count', 1) {
		assert_difference('Package.count', 1) {
			dust_kit = create_dust_kit(
				:kit_package_attributes => Factory.attributes_for(:package) )
		} }
	end

	test "should create dust_kit with dust_package" do
		assert_difference('DustKit.count', 1) {
		assert_difference('Package.count', 1) {
			dust_kit = create_dust_kit(
				:dust_package_attributes => Factory.attributes_for(:package) )
		} }
	end

	test "should create dust_kit with both packages" do
		assert_difference('DustKit.count', 1) {
		assert_difference('Package.count', 2) {
			dust_kit = create_dust_kit(
				:kit_package_attributes  => Factory.attributes_for(:package),
				:dust_package_attributes => Factory.attributes_for(:package) 
			)
		} }
	end

	test "should require a unique subject" do
		assert_difference('DustKit.count', 2) {
		assert_difference('Subject.count', 1) {
			dust_kit = create_dust_kit
			assert_nil dust_kit.subject
			subject = Factory(:subject)
			dust_kit.update_attributes(:subject_id => subject.id)
			assert_not_nil dust_kit.subject
			dust_kit = create_dust_kit
			assert_nil dust_kit.subject
			dust_kit.update_attributes(:subject_id => subject.id)
			assert dust_kit.reload.errors.on(:subject_id)
		} }
	end

	test "should returned status New" do
		dust_kit = create_complete_dust_kit	
		assert_equal 'New', dust_kit.status
	end

	test "should returned status Shipped" do
		dust_kit = create_complete_dust_kit	
		dust_kit.kit_package.update_attribute(:status,'Transit')
		assert_equal 'Shipped', dust_kit.status
	end

	test "should returned status Delivered" do
		dust_kit = create_complete_dust_kit	
		dust_kit.kit_package.update_attribute(:status,'Delivered')
		assert_equal 'Delivered', dust_kit.status
	end

	test "should returned status Returned" do
		dust_kit = create_complete_dust_kit	
		dust_kit.dust_package.update_attribute(:status,'Transit')
		assert_equal 'Returned', dust_kit.status
	end

	test "should returned status Received" do
		dust_kit = create_complete_dust_kit	
		dust_kit.dust_package.update_attribute(:status,'Delivered')
		assert_equal 'Received', dust_kit.status
	end

	test "should return null sent_on with new kit" do
		dust_kit = create_complete_dust_kit	
		assert_nil dust_kit.sent_on
	end

	test "should return null received_on with new kit" do
		dust_kit = create_complete_dust_kit	
		assert_nil dust_kit.received_on
	end

	test "should return date sent_on with kit in transit" do
		stub_package_for_in_transit()
		dust_kit = create_complete_dust_kit	
		dust_kit.kit_package.update_status
		assert_not_nil dust_kit.sent_on
	end

	test "should return null received_on with kit in transit" do
		stub_package_for_in_transit()
		dust_kit = create_complete_dust_kit	
		dust_kit.kit_package.update_status
		assert_nil dust_kit.received_on
	end

	test "should return date sent_on with kit returned" do
		stub_package_for_successful_delivery()
		dust_kit = create_complete_dust_kit	
		dust_kit.kit_package.update_status
		dust_kit.dust_package.update_status
		assert_not_nil dust_kit.sent_on
	end

	test "should return date received_on with kit returned" do
		stub_package_for_successful_delivery()
		dust_kit = create_complete_dust_kit	
		dust_kit.dust_package.update_status
		assert_not_nil dust_kit.received_on
	end

protected

	def create_complete_dust_kit(options={})
		dust_kit = create_dust_kit(
			:kit_package_attributes  => Factory.attributes_for(:package),
			:dust_package_attributes => Factory.attributes_for(:package) 
		)
	end

	def create_dust_kit(options = {})
		record = Factory.build(:dust_kit,options)
		record.save
		record
	end
	alias_method :create_object, :create_dust_kit

end

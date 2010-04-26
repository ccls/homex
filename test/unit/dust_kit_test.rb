require File.dirname(__FILE__) + '/../test_helper'

class DustKitTest < ActiveSupport::TestCase

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

	test "should belong to a subject" do
		dust_kit = create_dust_kit
		assert_nil dust_kit.subject
		dust_kit.subject = Factory(:subject)
		assert_not_nil dust_kit.subject
	end

	test "should belong to a kit_package" do
		dust_kit = create_dust_kit
		assert_nil dust_kit.kit_package
		dust_kit.kit_package = Factory(:package)
		assert_not_nil dust_kit.kit_package
	end

	test "should belong to a dust_package" do
		dust_kit = create_dust_kit
		assert_nil dust_kit.dust_package
		dust_kit.dust_package = Factory(:package)
		assert_not_nil dust_kit.dust_package
	end

protected

	def create_dust_kit(options = {})
		record = Factory.build(:dust_kit,options)
		record.save
		record
	end

end

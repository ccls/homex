require File.dirname(__FILE__) + '/../test_helper'

class PackageTest < ActiveSupport::TestCase

	test "should create package" do
		assert_difference 'Package.count' do
			package = create_package
			assert !package.new_record?, 
				"#{package.errors.full_messages.to_sentence}"
		end
	end

	test "should require tracking_number" do
		assert_no_difference 'Package.count' do
			package = create_package(:tracking_number => nil)
			assert package.errors.on(:tracking_number)
		end
	end

	test "should require 3 char tracking_number" do
		assert_no_difference 'Package.count' do
			package = create_package(:tracking_number => 'Hi')
			assert package.errors.on(:tracking_number)
		end
	end

	test "should require unique tracking_number" do
		p = create_package
		assert_no_difference 'Package.count' do
			package = create_package(:tracking_number => p.tracking_number)
			assert package.errors.on(:tracking_number)
		end
	end

	test "should have no status when created" do
		package = create_package
		assert_nil package.status
	end

	test "should have failure status for bogus tracking_number" do
		stub_package_for_failure()
		assert_difference( 'Package.delivered.count', 0 ) {
		assert_difference( 'Package.undelivered.count', 1 ) {
			package = create_package(:tracking_number => 'obviouslybogus')
			package.update_status
			assert_match "failed", package.status
		} }
	end

	test "should have delivered status for delivered tracking_number" do
		stub_package_for_successful_delivery()
		assert_difference( 'Package.delivered.count', 1 ) {
		assert_difference( 'Package.undelivered.count', 0 ) {
			#	this number was taken from the active_shipping tests
			package = create_package(:tracking_number => '077973360403984')
			package.update_status
			assert_match "Delivered", package.status
		} }
	end

	test "should update status for undelivered" do
		stub_package_for_successful_delivery()
		package = create_package(:tracking_number => '077973360403984')
		assert_difference( 'Package.delivered.count', 1 ) {
		assert_difference( 'Package.undelivered.count', -1 ) {
			Package.update_undelivered
		} }
	end

	test "should set and get packages updated time" do
		if File.exists?(Package.packages_updated)
			File.delete(Package.packages_updated)
		end
		assert !File.exists?(Package.packages_updated)
		assert_nil Package.last_updated
		Package.just_updated
		assert File.exists?(Package.packages_updated)
		assert_in_delta Package.last_updated.to_f,
			Time.now.to_f, 2
	end

	test "should not be delivered? when new" do
		package = create_package
		assert !package.delivered?
	end

	test "should not be delivered? when in transit" do
		stub_package_for_in_transit()
		package = create_package
		assert !package.delivered?
		package.update_status
		assert !package.delivered?
		assert_equal 'Transit', package.status
	end

	test "should be delivered? when delivered" do
		stub_package_for_successful_delivery()
		package = create_package
		assert !package.delivered?
		package.update_status
		assert package.delivered?
	end

	test "should have many tracks" do
		package = create_package
		assert_equal 0, package.tracks.length
		Factory(:track, :trackable => package, 
			:time => Chronic.parse('yesterday') )
		assert_equal 1, package.reload.tracks.length
		Factory(:track, :trackable => package)
		assert_equal 2, package.reload.tracks.length
	end

protected

	def create_package(options = {})
		record = Factory.build(:package,options)
		record.save
		record
	end

end

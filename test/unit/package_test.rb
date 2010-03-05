require File.dirname(__FILE__) + '/../test_helper'

class PackageTest < ActiveSupport::TestCase

	test "should create package" do
		assert_difference 'Package.count' do
			package = create_package
			assert !package.new_record?, 
				"#{package.errors.full_messages.to_sentence}"
		end
	end

#	test "should require carrier" do
#		assert_no_difference 'Package.count' do
#			package = create_package(:carrier => nil)
#			assert package.errors.on(:carrier)
#		end
#	end

#	test "should require 3 char carrier" do
#		assert_no_difference 'Package.count' do
#			package = create_package(:carrier => 'Hi')
#			assert package.errors.on(:carrier)
#		end
#	end

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
		assert_difference( 'Package.delivered.count', 0 ) {
		assert_difference( 'Package.undelivered.count', 1 ) {
			package = create_package(:tracking_number => 'obviouslybogus')
			package.update_status
			assert_match "failed", package.status
		} }
	end

	test "should have delivered status for delivered tracking_number" do
		assert_difference( 'Package.delivered.count', 1 ) {
		assert_difference( 'Package.undelivered.count', 0 ) {
			#	this number was taken from the active_shipping tests
			package = create_package(:tracking_number => '077973360403984')
			package.update_status
			assert_match "Delivered", package.status
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
		assert_in_delta Package.last_updated,
			Time.now.to_f, 2
	end

protected

	def create_package(options = {})
		record = Factory.build(:package,options)
		record.save
		record
	end

end

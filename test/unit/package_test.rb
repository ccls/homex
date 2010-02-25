require File.dirname(__FILE__) + '/../test_helper'

class PackageTest < ActiveSupport::TestCase

	test "should create package" do
		assert_difference 'Package.count' do
			package = create_package
			assert !package.new_record?, "#{package.errors.full_messages.to_sentence}"
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

protected

	def create_package(options = {})
		record = Factory.build(:package,options)
		record.save
		record
	end

end

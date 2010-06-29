require File.dirname(__FILE__) + '/../test_helper'

class DataSourceTest < ActiveSupport::TestCase

	test "should create data_source" do
		assert_difference 'DataSource.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should have many addresses" do
		object = create_object
		assert_equal 0, object.addresses.length
		Factory(:address,:data_source_id => object.id)
		assert_equal 1, object.reload.addresses.length
		Factory(:address,:data_source_id => object.id)
		assert_equal 2, object.reload.addresses.length
	end

	test "should act as list" do
		object = create_object
		assert_equal 1, object.position
		object = create_object
		assert_equal 2, object.position
	end

protected

	def create_object(options = {})
		record = Factory.build(:data_source,options)
		record.save
		record
	end

end

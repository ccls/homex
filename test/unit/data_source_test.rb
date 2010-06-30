require File.dirname(__FILE__) + '/../test_helper'

class DataSourceTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:addresses)

	test "should create data_source" do
		assert_difference 'DataSource.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:data_source,options)
		record.save
		record
	end

end

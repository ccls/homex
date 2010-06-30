require File.dirname(__FILE__) + '/../test_helper'

class ExportTest < ActiveSupport::TestCase

	assert_should_require(:patid,:childid)
	assert_should_require_unique(:patid,:childid)

	test "should create export" do
		assert_difference 'Export.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:export,options)
		record.save
		record
	end

end

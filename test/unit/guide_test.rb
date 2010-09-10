require File.dirname(__FILE__) + '/../test_helper'

class GuideTest < ActiveSupport::TestCase

	assert_should_require_unique(:action,
		:scope => :controller)

	test "should create guide" do
		assert_difference 'Guide.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:guide,options)
		record.save
		record
	end

end

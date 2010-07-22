require File.dirname(__FILE__) + '/../test_helper'

class SampleTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:subject,:unit,:sample_type)
	assert_should_have_one(:sample_kit)
	assert_should_have_many(:aliquots)
	assert_should_belong_to(:aliquot_sample_format)
	assert_should_initially_belong_to(:subject,:unit,:sample_type)
	assert_should_habtm(:projects)

	test "should create sample" do
		assert_difference 'Sample.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should default order_no to 1" do
		object = create_object
		assert_equal 1, object.order_no
	end

	test "should default aliquot_or_sample_on_receipt to 'Sample'" do
		object = create_object
		assert_equal 'Sample', object.aliquot_or_sample_on_receipt
	end

#	somehow

	test "should belong to organization" do
#		object = create_object
#		assert_nil object.organization
#		object.organization = Factory(:organization)
#		assert_not_nil object.organization

#	TODO

		#	this is not clear in my UML diagram

		pending
	end

protected

	def create_object(options = {})
		record = Factory.build(:sample,options)
		record.save
		record
	end

end

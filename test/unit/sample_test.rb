require File.dirname(__FILE__) + '/../test_helper'

class SampleTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_requires_valid_associations(:subject,:sample_type)
	assert_should_have_one(:sample_kit)
	assert_should_have_many(:aliquots)
	assert_should_belong_to(:aliquot_sample_format,:unit)
	assert_should_initially_belong_to(:subject,:sample_type)
	assert_should_habtm(:projects)

	assert_requires_complete_date( :sent_to_subject_on,
		:received_by_ccls_on,
		:sent_to_lab_on,
		:received_by_lab_on,
		:aliquotted_on,
		:receipt_confirmed_on )

	test "should require that kit and sample tracking " <<
		"numbers are different" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(:sample_kit_attributes => {
				:kit_package_attributes => {
					:tracking_number => 'bogus_tracking_number'
				},
				:sample_package_attributes => {
					:tracking_number => 'bogus_tracking_number'
				}
			})
			assert object.errors.on(:base)
			assert_match(/Tracking numbers MUST be different/,
				object.errors.on(:base) )
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

end

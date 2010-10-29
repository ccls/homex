require File.dirname(__FILE__) + '/../test_helper'

class SampleTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_requires_valid_associations(:subject,:sample_type)
	assert_should_have_one(:sample_kit)
	assert_should_have_many(:aliquots)
	assert_should_belong_to(:aliquot_sample_format,:unit)
	assert_should_initially_belong_to(:subject,:sample_type)
	assert_should_habtm(:projects)

	assert_should_require_attributes(
		:sample_type_id,
		:subject_id )
	assert_should_not_require_attributes(
		:position,
		:aliquot_sample_format_id,
		:unit_id,
		:order_no,
		:quantity_in_sample,
		:aliquot_or_sample_on_receipt,
		:sent_to_subject_on,
		:received_by_ccls_on,
		:sent_to_lab_on,
		:received_by_lab_on,
		:aliquotted_on,
		:external_id,
		:external_id_source,
		:receipt_confirmed_on,
		:receipt_confirmed_by )

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

	test "should require sent_to_subject_on if received_by_ccls_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:sent_to_subject_on => nil,
				:received_by_ccls_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:sent_to_subject_on)
			assert_match(/be blank/,
				object.errors.on(:sent_to_subject_on) )
		end
	end

	test "should require received_by_ccls_on be after sent_to_subject_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:sent_to_subject_on => Chronic.parse('tomorrow'),
				:received_by_ccls_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:received_by_ccls_on)
			assert_match(/after sent_to_subject_on/,
				object.errors.on(:received_by_ccls_on) )
		end
	end

	test "should require received_by_ccls_on if sent_to_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:received_by_ccls_on => nil,
				:sent_to_lab_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:received_by_ccls_on)
			assert_match(/be blank/,
				object.errors.on(:received_by_ccls_on) )
		end
	end

	test "should require sent_to_lab_on be after received_by_ccls_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:received_by_ccls_on => Chronic.parse('tomorrow'),
				:sent_to_lab_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:sent_to_lab_on)
			assert_match(/after received_by_ccls_on/,
				object.errors.on(:sent_to_lab_on) )
		end
	end

	test "should require sent_to_lab_on if received_by_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:sent_to_lab_on => nil,
				:received_by_lab_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:sent_to_lab_on)
			assert_match(/be blank/,
				object.errors.on(:sent_to_lab_on) )
		end
	end

	test "should require received_by_lab_on be after sent_to_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:sent_to_lab_on => Chronic.parse('tomorrow'),
				:received_by_lab_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:received_by_lab_on)
			assert_match(/after sent_to_lab_on/,
				object.errors.on(:received_by_lab_on) )
		end
	end

	test "should require received_by_lab_on if aliquotted_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:received_by_lab_on => nil,
				:aliquotted_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:received_by_lab_on)
			assert_match(/be blank/,
				object.errors.on(:received_by_lab_on) )
		end
	end

	test "should require aliquotted_on be after received_by_lab_on" do
		assert_difference( 'Sample.count', 0 ) do
			object = create_object(
				:received_by_lab_on => Chronic.parse('tomorrow'),
				:aliquotted_on => Chronic.parse('yesterday')
			)
			assert object.errors.on(:aliquotted_on)
			assert_match(/after received_by_lab_on/,
				object.errors.on(:aliquotted_on) )
		end
	end

end

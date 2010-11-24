require File.dirname(__FILE__) + '/../test_helper'

class ExportTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes(:patid)
	assert_should_require_attributes(:childid)
	assert_should_require_unique_attributes(:patid)
	assert_should_require_unique_attributes(:childid)
	assert_should_not_require_attributes( :first_name )
	assert_should_not_require_attributes( :middle_name )
	assert_should_not_require_attributes( :last_name )
	assert_should_not_require_attributes( :diagnosis_date )
	assert_should_not_require_attributes( :type )
	assert_should_not_require_attributes( :orderno )
	assert_should_not_require_attributes( :mother_first_name )
	assert_should_not_require_attributes( :mother_middle_name )
	assert_should_not_require_attributes( :mother_last_name )
	assert_should_not_require_attributes( :father_first_name )
	assert_should_not_require_attributes( :father_middle_name )
	assert_should_not_require_attributes( :father_last_name )
	assert_should_not_require_attributes( :hospital_code )
	assert_should_not_require_attributes( :comments )
	assert_should_not_require_attributes( :is_eligible )
	assert_should_not_require_attributes( :is_chosen )
	assert_should_not_require_attributes( :reference_date )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :first_name )
		o.assert_should_require_attribute_length( :middle_name )
		o.assert_should_require_attribute_length( :last_name )
		o.assert_should_require_attribute_length( :type )
		o.assert_should_require_attribute_length( :orderno )
		o.assert_should_require_attribute_length( :mother_first_name )
		o.assert_should_require_attribute_length( :mother_middle_name )
		o.assert_should_require_attribute_length( :mother_last_name )
		o.assert_should_require_attribute_length( :father_first_name )
		o.assert_should_require_attribute_length( :father_middle_name )
		o.assert_should_require_attribute_length( :father_last_name )
		o.assert_should_require_attribute_length( :hospital_code )
	end

end

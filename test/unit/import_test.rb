require File.dirname(__FILE__) + '/../test_helper'

class ImportTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_not_require_attributes( :dob )
	assert_should_not_require_attributes( :diagnosis_date )
	assert_should_not_require_attributes( :first_name )
	assert_should_not_require_attributes( :middle_name )
	assert_should_not_require_attributes( :last_name )
	assert_should_not_require_attributes( :sex )
	assert_should_not_require_attributes( :language_code )
	assert_should_not_require_attributes( :is_hispanic )
	assert_should_not_require_attributes( :race )
	assert_should_not_require_attributes( :primary_phone_number )
	assert_should_not_require_attributes( :alternate_phone_number )
	assert_should_not_require_attributes( :dust_kit_sent_on )
	assert_should_not_require_attributes( :completed_interview_on )
	assert_should_not_require_attributes( :case_assigned_on )
	assert_should_not_require_attributes( :respondent_type )
	assert_should_not_require_attributes( :respondent_first_name )
	assert_should_not_require_attributes( :respondent_middle_name )
	assert_should_not_require_attributes( :respondent_last_name )
	assert_should_not_require_attributes( :last_action_on )
	assert_should_not_require_attributes( :respondent_address_line_1 )
	assert_should_not_require_attributes( :respondent_address_line_2 )
	assert_should_not_require_attributes( :respondent_city )
	assert_should_not_require_attributes( :respondent_state )
	assert_should_not_require_attributes( :respondent_zip )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :first_name )
		o.assert_should_require_attribute_length( :middle_name )
		o.assert_should_require_attribute_length( :last_name )
		o.assert_should_require_attribute_length( :sex )
		o.assert_should_require_attribute_length( :language_code )
		o.assert_should_require_attribute_length( :race )
		o.assert_should_require_attribute_length( :primary_phone_number )
		o.assert_should_require_attribute_length( :alternate_phone_number )
		o.assert_should_require_attribute_length( :respondent_type )
		o.assert_should_require_attribute_length( :respondent_first_name )
		o.assert_should_require_attribute_length( :respondent_middle_name )
		o.assert_should_require_attribute_length( :respondent_last_name )
		o.assert_should_require_attribute_length( :respondent_address_line_1 )
		o.assert_should_require_attribute_length( :respondent_address_line_2 )
		o.assert_should_require_attribute_length( :respondent_city )
		o.assert_should_require_attribute_length( :respondent_state )
		o.assert_should_require_attribute_length( :respondent_zip )
	end

end

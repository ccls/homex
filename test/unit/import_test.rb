require File.dirname(__FILE__) + '/../test_helper'

class ImportTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_not_require_attributes(
		:dob,
		:diagnosis_date,
		:first_name,
		:middle_name,
		:last_name,
		:sex,
		:language_code,
		:is_hispanic,
		:race,
		:primary_phone_number,
		:alternate_phone_number,
		:dust_kit_sent_on,
		:completed_interview_on,
		:case_assigned_on,
		:respondent_type,
		:respondent_first_name,
		:respondent_middle_name,
		:respondent_last_name,
		:last_action_on,
		:respondent_address_line_1,
		:respondent_address_line_2,
		:respondent_city,
		:respondent_state,
		:respondent_zip )

end

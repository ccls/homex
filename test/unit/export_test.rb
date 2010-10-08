require File.dirname(__FILE__) + '/../test_helper'

class ExportTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes(:patid,:childid)
	assert_should_require_unique_attributes(:patid,:childid)
	assert_should_not_require_attributes(
		:first_name,
		:middle_name,
		:last_name,
		:diagnosis_date,
		:type,
		:orderno,
		:mother_first_name,
		:mother_middle_name,
		:mother_last_name,
		:father_first_name,
		:father_middle_name,
		:father_last_name,
		:hospital_code,
		:comments,
		:is_eligible,
		:is_chosen,
		:reference_date )

end

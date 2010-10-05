require File.dirname(__FILE__) + '/../test_helper'

class ExportTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes(:patid,:childid)
	assert_should_require_unique_attributes(:patid,:childid)

end

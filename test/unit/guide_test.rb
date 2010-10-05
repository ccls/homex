require File.dirname(__FILE__) + '/../test_helper'

class GuideTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_unique_attribute(:action,
		:scope => :controller)

end

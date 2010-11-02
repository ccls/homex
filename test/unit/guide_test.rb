require File.dirname(__FILE__) + '/../test_helper'

class GuideTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_unique_attribute(:action, :scope => :controller)
	assert_should_not_require_attributes( :controller )
	assert_should_not_require_attributes( :body )
	assert_should_require_attribute_length( :controller, :maximum => 250 )
	assert_should_require_attribute_length( :action,     :maximum => 250 )

end

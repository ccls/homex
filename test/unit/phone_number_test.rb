require File.dirname(__FILE__) + '/../test_helper'

class PhoneNumberTest < ActiveSupport::TestCase

	assert_should_act_as_list :scope => :subject_id
	assert_should_belong_to :subject

end

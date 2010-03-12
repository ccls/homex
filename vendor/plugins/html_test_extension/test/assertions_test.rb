require File.dirname(__FILE__) + '/test_helper'

class AssertionsTest < ActiveSupport::TestCase

	test "ValidateFilter contains assert_validates method chain" do
		methods = Html::Test::ValidateFilter.new(
			ActionController::Base.new).methods
		assert methods.include?('assert_validates')
		assert methods.include?('assert_validates_with_verbosity_control')
		assert methods.include?('assert_validates_without_verbosity_control')
	end

end

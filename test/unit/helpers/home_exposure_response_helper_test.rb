require File.dirname(__FILE__) + '/../../test_helper'

class HomeExposureResponseHelperTest < ActionView::TestCase

	test "should show row without value" do
		@he = Factory(:home_exposure_response)
		HomeExposureResponse.field_names.each do |field_name|
			response = HTML::Document.new(show_row(:he,field_name)).root
			assert_select response, 'tr', 1 do
				assert_select 'td', 3
			end
		end
	end

	test "should show row with value" do
		@he = Factory(:home_exposure_response)
		HomeExposureResponse.field_names.each do |field_name|
			response = HTML::Document.new(
				show_row(:he,field_name,:value => 'fake')).root
			assert_select response, 'tr', 1 do
				assert_select 'td', 3
			end
		end
	end

end

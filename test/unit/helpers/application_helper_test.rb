require File.dirname(__FILE__) + '/../../test_helper'

class ApplicationHelperTest < ActionView::TestCase

	test "mdy should return mdy date with date" do
		response = mdy(Date.parse('Dec 31, 1999'))
		assert_match '12/31/1999', response
	end

	test "mdy should return nbsp with nil date" do
		response = mdy(nil)
		assert_match '&nbsp;', response
	end

	test "y_n_dk should return 'Yes' with 1" do
		response = y_n_dk(1)
		assert_match 'Yes', response
	end

	test "y_n_dk should return 'No' with 2" do
		response = y_n_dk(2)
		assert_match 'No', response
	end

	test "y_n_dk should return 'Don\'t Know' with 999" do
		response = y_n_dk(999)
		assert_match "Don't Know", response
	end

	test "y_n_dk should return 'nbsp' with other" do
		response = y_n_dk(nil)
		assert_match '&nbsp;', response
	end

end

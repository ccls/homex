require 'test_helper'

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

#	test "answer_text should return blank without value" do
#		response = answer_text(:bogus_method,'')
#		assert response.blank?
#	end
#
#	test "answer_text should return blank with nbsp value" do
#		response = answer_text(:bogus_method,'&nbsp;')
#		assert response.blank?
#	end
#
#	test "answer_text should not return blank with non-space value" do
#		response = answer_text(:bogus_method,'bogus_value')
#		assert !response.blank?
#	end
#
#	test "answer_text should return 'question not found?' with non-existant method" do
#		response = answer_text(:bogus_method,'bogus_value')
#		assert_equal 'question not found?', response
#	end

	test "decode_yndk 0 should return &nbsp;" do
		response = decode_yndk(0)
		assert_equal "&nbsp;", response
	end

	test "decode_yndk 1 should return yes" do
		response = decode_yndk(1)
		assert_equal "1 = Yes", response
	end

	test "decode_yndk 2 should return no" do
		response = decode_yndk(2)
		assert_equal "2 = No", response
	end

	test "decode_yndk 999 should return don't know" do
		response = decode_yndk(999)
		assert_equal "9 = Don't Know", response
	end


	test "decode_osrn 0 should return &nbsp;" do
		response = decode_osrn(0)
		assert_equal "&nbsp;", response
	end

	test "decode_osrn 1 should return often" do
		response = decode_osrn(1)
		assert_equal "1 = Often", response
	end

	test "decode_osrn 2 should return sometimes" do
		response = decode_osrn(2)
		assert_equal "2 = Sometimes", response
	end

	test "decode_osrn 3 should return rarely" do
		response = decode_osrn(3)
		assert_equal "3 = Rarely", response
	end

	test "decode_osrn 4 should return never" do
		response = decode_osrn(4)
		assert_equal "4 = Never", response
	end

	test "decode_freq1 0 should return &nbsp;" do
		response = decode_freq1(0)
		assert_equal "&nbsp;", response
	end

	test "decode_freq1 1 should return everyday" do
		response = decode_freq1(1)
		assert_equal "1 = Every day (or almost every day)", response
	end

	test "decode_freq1 2 should return couple times per week" do
		response = decode_freq1(2)
		assert_equal "2 = 1-2 times per week", response
	end

	test "decode_freq1 3 should return couple times per month" do
		response = decode_freq1(3)
		assert_equal "3 = 1-2 times per month", response
	end

	test "decode_freq1 4 should return less than once per month" do
		response = decode_freq1(4)
		assert_equal "4 = less than one time per month", response
	end

	test "decode_freq1 5 should return never" do
		response = decode_freq1(5)
		assert_equal "5 = Never", response
	end

	test "decode_freq1 999 should return don't know" do
		response = decode_freq1(999)
		assert_equal "9 = Don't Know", response
	end

	test "decode_freq2 0 should return &nbsp;" do
		response = decode_freq2(0)
		assert_equal "&nbsp;", response
	end

	test "decode_freq2 1 should return everyday" do
		response = decode_freq2(1)
		assert_equal "1 = Every day or almost everyday", response
	end

	test "decode_freq2 2 should return once a week" do
		response = decode_freq2(2)
		assert_equal "2 = About once a week", response
	end

	test "decode_freq2 3 should return couple times a month" do
		response = decode_freq2(3)
		assert_equal "3 = A few times a month", response
	end

	test "decode_freq2 4 should return couple times a year" do
		response = decode_freq2(4)
		assert_equal "4 = A few times a year", response
	end

	test "decode_freq2 5 should return never" do
		response = decode_freq2(5)
		assert_equal "5 = Never", response
	end

	test "decode_freq2 999 should return don't know" do
		response = decode_freq2(999)
		assert_equal "9 = Don't Know", response
	end

	test "decode_freq3 0 should return &nbsp;" do
		response = decode_freq3(0)
		assert_equal "&nbsp;", response
	end

	test "decode_freq3 1 should return less than once a month" do
		response = decode_freq3(1)
		assert_equal "1 = Less than once a month", response
	end

	test "decode_freq3 2 should return a couple times a month" do
		response = decode_freq3(2)
		assert_equal "2 = 1-3 times a month", response
	end

	test "decode_freq3 3 should return once a week" do
		response = decode_freq3(3)
		assert_equal "3 = Once a week", response
	end

	test "decode_freq3 4 should return more than once a week" do
		response = decode_freq3(4)
		assert_equal "4 = More than once a week", response
	end

	test "decode_freq3 999 should return don't know" do
		response = decode_freq3(999)
		assert_equal "9 = Don't Know", response
	end

	test "decode_quantity 0 should return &nbsp;" do
		response = decode_quantity(0)
		assert_equal "&nbsp;", response
	end

	test "decode_quantity 1 should return 0" do
		response = decode_quantity(1)
		assert_equal "1 = 0", response
	end

	test "decode_quantity 2 should return 1-2" do
		response = decode_quantity(2)
		assert_equal "2 = 1-2", response
	end

	test "decode_quantity 3 should return 3-5" do
		response = decode_quantity(3)
		assert_equal "3 = 3-5", response
	end

	test "decode_quantity 4 should return more than 5" do
		response = decode_quantity(4)
		assert_equal "4 = More than 5", response
	end

	test "decode_quantity 999 should return don't know" do
		response = decode_quantity(999)
		assert_equal "9 = Don't Know", response
	end

	test "decode_doneness 0 should return &nbsp;" do
		response = decode_doneness(0)
		assert_equal "&nbsp;", response
	end

	test "decode_doneness 1 should return not browned" do
		response = decode_doneness(1)
		assert_equal "1 = Not browned", response
	end

	test "decode_doneness 2 should return lightly browned" do
		response = decode_doneness(2)
		assert_equal "2 = Lightly-browned", response
	end

	test "decode_doneness 3 should return well browned" do
		response = decode_doneness(3)
		assert_equal "3 = Well-browned", response
	end

	test "decode_doneness 4 should return charred" do
		response = decode_doneness(4)
		assert_equal "4 = Black or charred", response
	end

	test "decode_doneness 5 should return varies" do
		response = decode_doneness(5)
		assert_equal "5 = It varies (volunteered code)", response
	end

	test "decode_doneness 999 should return don't know" do
		response = decode_doneness(999)
		assert_equal "9 = Don't Know", response
	end

	test "decode_residence 0 should return &nbsp;" do
		response = decode_residence(0)
		assert_equal "&nbsp;", response
	end

	test "decode_residence 1 should return single" do
		response = decode_residence(1)
		assert_equal "1 = Single family residence", response
	end

	test "decode_residence 2 should return duplex" do
		response = decode_residence(2)
		assert_equal "2 = Duplex / Townhouse", response
	end

	test "decode_residence 3 should return apartment" do
		response = decode_residence(3)
		assert_equal "3 = Apartment / Condominium", response
	end

	test "decode_residence 4 should return mobile" do
		response = decode_residence(4)
		assert_equal "4 = Mobile Home", response
	end

	test "decode_residence 8 should return other" do
		response = decode_residence(8)
		assert_equal "8 = Other (specify)", response
	end

	test "decode_residence 999 should return don't know" do
		response = decode_residence(999)
		assert_equal "9 = Don't Know", response
	end

	test "decode_material 0 should return &nbsp;" do
		response = decode_material(0)
		assert_equal "&nbsp;", response
	end

	test "decode_material 1 should return wood" do
		response = decode_material(1)
		assert_equal "1 = Wood", response
	end

	test "decode_material 2 should return mason" do
		response = decode_material(2)
		assert_equal "2 = Mason / Brick / Cement", response
	end

	test "decode_material 3 should return prefab" do
		response = decode_material(3)
		assert_equal "3 = Pre-fabricated panels", response
	end

	test "decode_material 8 should return something else" do
		response = decode_material(8)
		assert_equal "8 = Something Else (specify)", response
	end

	test "decode_material 999 should return don't know" do
		response = decode_material(999)
		assert_equal "9 = Don't Know", response
	end

	test "decode_percent 0 should return &nbsp;" do
		response = decode_percent(0)
		assert_equal "&nbsp;", response
	end

	test "decode_percent 1 should return less than 25" do
		response = decode_percent(1)
		assert_equal "1 = Less than 25%", response
	end

	test "decode_percent 2 should return 25-49" do
		response = decode_percent(2)
		assert_equal "2 = 25% - 49%", response
	end

	test "decode_percent 3 should return 50-74" do
		response = decode_percent(3)
		assert_equal "3 = 50% - 74%", response
	end

	test "decode_percent 4 should return 75-100" do
		response = decode_percent(4)
		assert_equal "4 = 75% - 100%", response
	end

	test "decode_percent 999 should return don't know" do
		response = decode_percent(999)
		assert_equal "9 = Don't Know", response
	end

	test "decode_five 0 should return &nbsp;" do
		response = decode_five(0)
		assert_equal "&nbsp;", response
	end

	test "decode_five 1 should return 5 or more" do
		response = decode_five(1)
		assert_equal "1 = 5 or more time", response
	end

	test "decode_five 2 should return less than 5" do
		response = decode_five(2)
		assert_equal "2 = Fewer than 5 times", response
	end

	test "decode_hours 0 should return &nbsp;" do
		response = decode_hours(0)
		assert_equal "&nbsp;", response
	end

	test "decode_hours 1 should return less than 1 per day" do
		response = decode_hours(1)
		assert_equal "1 = less than one hour per day", response
	end

	test "decode_hours 2 should return 1-2 per day" do
		response = decode_hours(2)
		assert_equal "2 = 1-2 hours per day", response
	end

	test "decode_hours 3 should return 3-6 per day" do
		response = decode_hours(3)
		assert_equal "3 = 3-6 hours per day", response
	end

	test "decode_hours 4 should return more than 6 per day" do
		response = decode_hours(4)
		assert_equal "4 = More than 6 hours per day", response
	end

	test "decode_hours 999 should return don't know" do
		response = decode_hours(999)
		assert_equal "9 = Don't Know", response
	end

	test "decode_ 0 should return 0" do
		response = decode_(0)
		assert_equal 0, response
	end

	test "decode_ 999 should return 999" do
		response = decode_(999)
		assert_equal 999, response
	end

end

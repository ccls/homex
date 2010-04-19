require File.dirname(__FILE__) + '/../test_helper'

class HomePagePicTest < ActiveSupport::TestCase

	test "should create home_page_pic" do
		assert_difference 'HomePagePic.count' do
			home_page_pic = create_home_page_pic
			assert !home_page_pic.new_record?, 
				"#{home_page_pic.errors.full_messages.to_sentence}"
		end
	end

	test "should require title" do
		assert_no_difference 'HomePagePic.count' do
			home_page_pic = create_home_page_pic(:title => nil)
			assert home_page_pic.errors.on(:title)
		end
	end

	test "should require 4 char title" do
		assert_no_difference 'HomePagePic.count' do
			home_page_pic = create_home_page_pic(:title => 'Hey')
			assert home_page_pic.errors.on(:title)
		end
	end

	test "should return random HPP" do
		active   = Factory(:home_page_pic, :active => true)
		inactive = Factory(:home_page_pic, :active => false)
		assert_equal active, HomePagePic.random_active()
	end

protected

	def create_home_page_pic(options = {})
		record = Factory.build(:home_page_pic,options)
		record.save
		record
	end

end

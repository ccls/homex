require File.dirname(__FILE__) + '/../test_helper'

class HomePagePicTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes(:title)
	assert_should_not_require_attributes(
		:caption, :active )

	test "should require 4 char title" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:title => 'Hey')
			assert object.errors.on(:title)
		end
	end

	test "should return random HPP" do
		active   = Factory(:home_page_pic, :active => true, 
			:image_file_name => 'some_fake_file_name')
		inactive = Factory(:home_page_pic, :active => false, 
			:image_file_name => 'some_fake_file_name')
		assert_equal active, HomePagePic.random_active()
	end

end

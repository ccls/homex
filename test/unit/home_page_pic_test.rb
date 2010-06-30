require File.dirname(__FILE__) + '/../test_helper'

class HomePagePicTest < ActiveSupport::TestCase

	assert_should_require(:title)

	test "should create home_page_pic" do
		assert_difference 'HomePagePic.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require 4 char title" do
		assert_no_difference 'HomePagePic.count' do
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

protected

	def create_object(options = {})
		record = Factory.build(:home_page_pic,options)
		record.save
		record
	end

end

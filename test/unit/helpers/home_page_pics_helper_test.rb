require File.dirname(__FILE__) + '/../../test_helper'

class HomePagePicsHelperTest < ActionView::TestCase
	
	test "active_check_box requires valid hpp" do
		assert_raise(RuntimeError){
			active_check_box(nil)
		}
	end

	test "active_check_box should return div.active" do
		hpp = Factory(:home_page_pic)
		response = HTML::Document.new(active_check_box(hpp)).root
		assert_select response, 'div.active', 1
	end

	test "active_check_box should return inputs and label" do
		hpp = Factory(:home_page_pic)
		response = HTML::Document.new(active_check_box(hpp)).root
		assert_select response, 'div.active', 1 do
			assert_select 'input', 2
			assert_select 'label', 1
		end
	end

end

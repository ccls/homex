require File.dirname(__FILE__) + '/../test_helper'

class LocalesControllerTest < ActionController::TestCase

	test "should set locale" do
		assert_nil session[:locale]
		get :show, :id => 'en'
		assert_equal 'en', session[:locale]
	end

end

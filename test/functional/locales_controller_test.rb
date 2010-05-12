require File.dirname(__FILE__) + '/../test_helper'

class LocalesControllerTest < ActionController::TestCase

	test "should set locale to en" do
		assert_nil session[:locale]
		get :show, :id => 'en'
		assert_equal 'en', session[:locale]
	end

	test "should change locale to es" do
		assert_nil session[:locale]
		session[:locale] = 'en'
		assert_equal 'en', session[:locale]
		get :show, :id => 'es'
		assert_equal 'es', session[:locale]
	end

end

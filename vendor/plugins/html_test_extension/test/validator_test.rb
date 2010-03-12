require File.dirname(__FILE__) + '/test_helper'

class ValidatorTest < ActiveSupport::TestCase

	def setup
		Html::Test::Validator.verbose = true
		Html::Test::Validator.revalidate_all = true	
		#	class variables need manually reset
		#	which makes testing the default kind 
		#	difficult
	end

	test "verbose is true by default" do
		assert Html::Test::Validator.verbose
	end

	test "verbose can be set to false" do
		Html::Test::Validator.verbose = false
		assert !Html::Test::Validator.verbose
	end

	test "revalidate_all is true by default" do
		assert Html::Test::Validator.revalidate_all
	end

	test "revalidate_all can be set to false" do
		Html::Test::Validator.revalidate_all = false
		assert !Html::Test::Validator.revalidate_all
	end

end

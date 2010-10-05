require File.dirname(__FILE__) + '/../test_helper'

class AnalysisTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes(:code,:description)
	assert_should_require_unique_attributes(:code,:description)
	assert_should_belong_to(:analytic_file_creator, 
		:class_name => 'Person')
	assert_should_belong_to(:analyst, 
		:class_name => 'Person')
	assert_should_belong_to(:project)
	assert_should_habtm(:subjects)


	test "should require 4 char description" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

end

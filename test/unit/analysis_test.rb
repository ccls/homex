require File.dirname(__FILE__) + '/../test_helper'

class AnalysisTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes(:code,:description)
	assert_should_require_unique_attributes(:code,:description)
	assert_should_not_require_attributes(
		:analyst_id, :project_id,
		:analytic_file_creator_id,
		:analytic_file_created_date,
		:analytic_file_last_pulled_date,
		:analytic_file_location,
		:analytic_file_filename )

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

require File.dirname(__FILE__) + '/../test_helper'

class AnalysisTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes(:code)
	assert_should_require_attributes(:description)
	assert_should_require_attribute_length(:description, :maximum => 250, :minimum => 4)
	assert_should_require_attribute_length( :code, :maximum => 250 )
	assert_should_require_unique_attributes(:code)
	assert_should_require_unique_attributes(:description)
	assert_should_not_require_attributes( :analyst_id )
	assert_should_not_require_attributes( :project_id )
	assert_should_not_require_attributes( :analytic_file_creator_id )
	assert_should_not_require_attributes( :analytic_file_created_date )
	assert_should_not_require_attributes( :analytic_file_last_pulled_date )
	assert_should_not_require_attributes( :analytic_file_location )
	assert_should_not_require_attributes( :analytic_file_filename )

	assert_should_belong_to(:analytic_file_creator, :class_name => 'Person')
	assert_should_belong_to(:analyst,               :class_name => 'Person')
	assert_should_belong_to(:project)
	assert_should_habtm(:subjects)

end

require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_many(
		:operational_event_types,:interview_types,:enrollments,
		:instruments)
	assert_should_require_attributes(:code,:description)
	assert_should_require_unique_attributes(:code,:description)
	assert_should_habtm(:samples)
	assert_should_act_as_list

	assert_requires_complete_date( :began_on, :ended_on )

	test "should require 4 char description" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

	test "should have many subjects through enrollments" do
		object = create_object
		assert_equal 0, object.subjects.length
		Factory(:enrollment, :project_id => object.id)
		assert_equal 1, object.reload.subjects.length
		Factory(:enrollment, :project_id => object.id)
		assert_equal 2, object.reload.subjects.length
	end

	test "should find by code with ['string']" do
		object = Project['HomeExposures']
		assert object.is_a?(Project)
	end

	test "should find by code with [:symbol]" do
		object = Project[:HomeExposures]
		assert object.is_a?(Project)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(Project::NotFound) {
#			object = Project['idonotexist']
#		}
#	end

end

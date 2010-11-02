require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_many(
		:operational_event_types,:interview_types,:enrollments,
		:instruments,:gift_cards)
	assert_should_require_attributes(:code,:description)
	assert_should_require_unique_attributes(:code,:description)
	assert_should_not_require_attributes(
		:position,
		:began_on,
		:ended_on,
		:eligibility_criteria )
	assert_should_habtm(:samples)
	assert_should_act_as_list
	assert_should_require_attribute_length(
		:code, :description,
		:maximum => 250 )

	assert_requires_complete_date( :began_on, :ended_on )
	assert_should_require_attribute_length(:description, :minimum => 4)


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

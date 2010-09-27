require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < ActiveSupport::TestCase

	assert_should_have_many(
		:operational_event_types,:interview_types,:enrollments,
		:instruments)
	assert_should_require(:code,:description)
	assert_should_require_unique(:code,:description)
	assert_should_habtm(:samples)
#	assert_should_have_many(:subjects,:through => :enrollments)

	test "should create project" do
		assert_difference 'Project.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'Project.count' do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
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

protected

	def create_object(options = {})
		record = Factory.build(:project,options)
		record.save
		record
	end

end

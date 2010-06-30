require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < ActiveSupport::TestCase

	assert_should_have_many(
		:operational_event_types,:interview_types,:project_subjects)
	assert_should_require(:code,:description)
	assert_should_require_unique(:code,:description)

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

	test "should have many subjects through project_subjects" do
		object = create_object
		assert_equal 0, object.subjects.length
		Factory(:project_subject, :project_id => object.id)
		assert_equal 1, object.reload.subjects.length
		Factory(:project_subject, :project_id => object.id)
		assert_equal 2, object.reload.subjects.length
	end

	test "should have and belong to many samples" do
		object = create_object
		assert_equal 0, object.samples.length
		object.samples << Factory(:sample)
		assert_equal 1, object.reload.samples.length
		object.samples << Factory(:sample)
		assert_equal 2, object.reload.samples.length
	end

protected

	def create_object(options = {})
		record = Factory.build(:project,options)
		record.save
		record
	end

end

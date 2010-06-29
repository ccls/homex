require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < ActiveSupport::TestCase

	test "should create project" do
		assert_difference 'Project.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'Project.count' do
			object = create_object(:description => nil)
			assert object.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'Project.count' do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should require unique description" do
		se = create_object
		assert_no_difference 'Project.count' do
			object = create_object(
				:description => se.description)
			assert object.errors.on(:description)
		end
	end

	test "should have many operational_event_types" do
		object = create_object
		assert_equal 0, object.operational_event_types.length
		Factory(:operational_event_type, :project_id => object.id)
		assert_equal 1, object.reload.operational_event_types.length
		Factory(:operational_event_type, :project_id => object.id)
		assert_equal 2, object.reload.operational_event_types.length
	end

	test "should have many interview_types" do
		object = create_object
		assert_equal 0, object.interview_types.length
		Factory(:interview_type, :project_id => object.id)
		assert_equal 1, object.reload.interview_types.length
		Factory(:interview_type, :project_id => object.id)
		assert_equal 2, object.reload.interview_types.length
	end

	test "should have many study_event_eligibilities" do
		object = create_object
		assert_equal 0, object.study_event_eligibilities.length
		Factory(:study_event_eligibility, :project_id => object.id)
		assert_equal 1, object.reload.study_event_eligibilities.length
		Factory(:study_event_eligibility, :project_id => object.id)
		assert_equal 2, object.reload.study_event_eligibilities.length
	end

	test "should have many project_subjects" do
		object = create_object
		assert_equal 0, object.project_subjects.length
		Factory(:project_subject, :project_id => object.id)
		assert_equal 1, object.reload.project_subjects.length
		Factory(:project_subject, :project_id => object.id)
		assert_equal 2, object.reload.project_subjects.length
	end

	test "should have many subjects through project_subjects" do
		object = create_object
		assert_equal 0, object.subjects.length
		Factory(:project_subject, :project_id => object.id)
		assert_equal 1, object.reload.subjects.length
		Factory(:project_subject, :project_id => object.id)
		assert_equal 2, object.reload.subjects.length
	end

protected

	def create_object(options = {})
		record = Factory.build(:project,options)
		record.save
		record
	end

end

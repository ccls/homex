require File.dirname(__FILE__) + '/../test_helper'

class AnalysisTest < ActiveSupport::TestCase

	test "should create analysis" do
		assert_difference 'Analysis.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require code" do
		assert_no_difference 'Analysis.count' do
			object = create_object(
				:code => nil)
			assert object.errors.on(:code)
		end
	end

	test "should require unique code" do
		oet = create_object
		assert_no_difference 'Analysis.count' do
			object = create_object(
				:code => oet.code)
			assert object.errors.on(:code)
		end
	end

	test "should require description" do
		assert_no_difference 'Analysis.count' do
			object = create_object(
				:description => nil)
			assert object.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'Analysis.count' do
			object = create_object(
				:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should require unique description" do
		oet = create_object
		assert_no_difference 'Analysis.count' do
			object = create_object(
				:description => oet.description)
			assert object.errors.on(:description)
		end
	end

	test "should have and belong to many subjects" do
		object = create_object
		assert_equal 0, object.subjects.length
		object.subjects << Factory(:subject)
		assert_equal 1, object.reload.subjects.length
		object.subjects << Factory(:subject)
		assert_equal 2, object.reload.subjects.length
	end

	test "should belong to an analytic_file_creator" do
		object = create_object
		assert_nil object.analytic_file_creator
		object.analytic_file_creator = Factory(:person)
		assert_not_nil object.analytic_file_creator
	end

	test "should belong to an analyst" do
		object = create_object
		assert_nil object.analyst
		object.analyst = Factory(:person)
		assert_not_nil object.analyst
	end

	test "should belong to a project" do
		object = create_object
		assert_nil object.project
		object.project = Factory(:project)
		assert_not_nil object.project
	end

protected

	def create_object(options = {})
		record = Factory.build(:analysis,options)
		record.save
		record
	end

end

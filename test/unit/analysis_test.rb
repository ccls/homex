require File.dirname(__FILE__) + '/../test_helper'

class AnalysisTest < ActiveSupport::TestCase

	assert_should_belong_to(:analytic_file_creator,:analyst,:project)
	assert_should_require(:code,:description)
	assert_should_require_unique(:code,:description)

	test "should create analysis" do
		assert_difference 'Analysis.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'Analysis.count' do
			object = create_object(
				:description => 'Hey')
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

protected

	def create_object(options = {})
		record = Factory.build(:analysis,options)
		record.save
		record
	end

end

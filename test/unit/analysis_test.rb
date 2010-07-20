require File.dirname(__FILE__) + '/../test_helper'

class AnalysisTest < ActiveSupport::TestCase

	assert_should_belong_to(:analytic_file_creator, 
		:class_name => 'Person')
	assert_should_belong_to(:analyst, 
		:class_name => 'Person')
	assert_should_belong_to(:project)
	assert_should_require(:code,:description)
	assert_should_require_unique(:code,:description)
	assert_should_habtm(:subjects)

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

protected

	def create_object(options = {})
		record = Factory.build(:analysis,options)
		record.save
		record
	end

end

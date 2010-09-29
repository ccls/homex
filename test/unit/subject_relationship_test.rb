require File.dirname(__FILE__) + '/../test_helper'

class SubjectRelationshipTest < ActiveSupport::TestCase

	assert_should_act_as_list
#	assert_should_have_many(:interviews)
	assert_should_require(:code,:description)
	assert_should_require_unique(:code,:description)

	test "should create subject_relationship" do
		assert_difference 'SubjectRelationship.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'SubjectRelationship.count' do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

	test "should find by code with ['string']" do
		object = SubjectRelationship['unknown']
		assert object.is_a?(SubjectRelationship)
	end

	test "should find by code with [:symbol]" do
		object = SubjectRelationship[:unknown]
		assert object.is_a?(SubjectRelationship)
	end

protected

	def create_object(options = {})
		record = Factory.build(:subject_relationship,options)
		record.save
		record
	end

end

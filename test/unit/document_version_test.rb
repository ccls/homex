require File.dirname(__FILE__) + '/../test_helper'

class DocumentVersionTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
#	assert_should_belong_to(:document_type)
	assert_should_initially_belong_to(:document_type)
	assert_should_have_many(:enrollments)
	assert_should_require(:document_type_id)
#	assert_should_require(:code,:description)
#	assert_should_require_unique(:code)	#,:description)

#	test "should create document_version" do
#		assert_difference( "#{model_name}.count", 1 ) do
#			object = create_object
#			assert !object.new_record?, 
#				"#{object.errors.full_messages.to_sentence}"
#		end
#	end

#	test "should require 4 char description" do
#		assert_no_difference 'VitalStatus.count' do
#			object = create_object(
#				:description => 'Hey')
#			assert object.errors.on(:description)
#		end
#	end

	test "should only return document type id == 1 for type1" do
		objects = DocumentVersion.type1
		assert_not_nil objects
		objects.each do |o|
			assert_equal 1, o.document_type_id
		end
	end

end

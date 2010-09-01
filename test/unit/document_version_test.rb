require File.dirname(__FILE__) + '/../test_helper'

class DocumentVersionTest < ActiveSupport::TestCase

	assert_should_act_as_list
#	assert_should_belong_to(:document_type)
	assert_should_initially_belong_to(:document_type)
	assert_should_have_many(:enrollments)
	assert_should_require(:document_type_id)
#	assert_should_require(:code,:description)
#	assert_should_require_unique(:code)	#,:description)

	test "should create document_version" do
		assert_difference 'DocumentVersion.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

#	test "should require 4 char description" do
#		assert_no_difference 'VitalStatus.count' do
#			object = create_object(
#				:description => 'Hey')
#			assert object.errors.on(:description)
#		end
#	end

protected

	def create_object(options = {})
		record = Factory.build(:document_version,options)
		record.save
		record
	end

end

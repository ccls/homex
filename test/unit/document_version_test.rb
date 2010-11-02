require File.dirname(__FILE__) + '/../test_helper'

class DocumentVersionTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:enrollments)

	assert_should_initially_belong_to(:document_type)
	assert_requires_valid_association(:document_type)
	assert_should_require_attributes(:document_type_id)
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :title )
	assert_should_not_require_attributes( :description )
	assert_should_not_require_attributes( :indicator)
	assert_should_require_attribute_length( :title,       :maximum => 250 )
	assert_should_require_attribute_length( :description, :maximum => 250 )
	assert_should_require_attribute_length( :indicator,   :maximum => 250 )

	test "should only return document type id == 1 for type1" do
		objects = DocumentVersion.type1
		assert_not_nil objects
		objects.each do |o|
			assert_equal 1, o.document_type_id
		end
	end

end

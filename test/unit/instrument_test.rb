require File.dirname(__FILE__) + '/../test_helper'

class InstrumentTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:instrument_versions)
	assert_should_belong_to(:interview_method)
	assert_should_initially_belong_to(:project)
#	assert_requires_valid_association(:project)
	assert_should_require_attributes(:code,:name,
		:project_id,
		:description)
	assert_should_require_attribute_length(:description, :minimum => 4)
	assert_should_require_unique_attributes(:code,:description)
	assert_should_not_require_attributes(
		:position,
		:results_table_id,
		:interview_method_id,
		:began_use_on,
		:ended_use_on )

	assert_requires_complete_date(:began_use_on,:ended_use_on)

	#	unfortunately name is NOT unique so should change this
	test "should return name as to_s" do
		object = create_object
		assert_equal object.name, "#{object}"
	end

end

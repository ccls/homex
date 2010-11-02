require File.dirname(__FILE__) + '/../test_helper'

class InstrumentVersionTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :interviews )
	assert_should_belong_to( :language )
	assert_should_belong_to( :instrument )
	assert_should_initially_belong_to( :interview_type )
	assert_requires_valid_associations( :interview_type )
	assert_should_require_attributes( :code )
	assert_should_require_attributes( :description )
	assert_should_require_attributes( :interview_type_id )
	assert_should_require_unique_attributes( :code )
	assert_should_require_unique_attributes( :description )
	assert_should_not_require_attributes(
		:position,
		:language_id,
		:began_use_on,
		:ended_use_on,
		:instrument_id )

	assert_requires_complete_date( :began_use_on )
	assert_requires_complete_date( :ended_use_on )
	assert_should_require_attribute_length( :code,        :maximum => 250 )
	assert_should_require_attribute_length( :description, :maximum => 250, :minimum => 4 )


	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

	test "should find by code with ['string']" do
		object = InstrumentVersion['unknown']
		assert object.is_a?(InstrumentVersion)
	end

	test "should find by code with [:symbol]" do
		object = InstrumentVersion[:unknown]
		assert object.is_a?(InstrumentVersion)
	end

	test "should find random" do
		object = InstrumentVersion.random()
		assert object.is_a?(InstrumentVersion)
	end

	test "should return nil on random when no records" do
		InstrumentVersion.stubs(:count).returns(0)
		object = InstrumentVersion.random()
		assert_nil object
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class TrackTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:trackable)
	assert_should_require_attributes(:trackable_id,:name,:time)
	assert_should_require_unique_attributes(:time, 
		:scope => [:trackable_id, :trackable_type])
	assert_should_not_require_attributes(
		:trackable_type,
		:location,
		:city,
		:state,
		:zip )
#	assert_should_require_attribute_length(
#		:name, :location, :city, :state, :zip,
#		:maximum => 250 )


	test "should require trackable_type" do
		#	kinda challenging to override the _type with 
		#	Factory girl apparently
		assert_difference( "#{model_name}.count", 0 ) do
			object = Factory.build(:track)
			object.trackable_type = nil
			object.save
			assert object.errors.on(:trackable_type)
		end
	end

	test "should combine city and state into location" do
		object = create_object(
			:city => "Berkeley", :state => "CA")
		assert_equal object.location, "Berkeley, CA"
	end

	test "should use just city in location if that's all that's given" do
		object = create_object(:city => "Berkeley")
		assert_equal object.location, "Berkeley"
	end

	test "should use just state in location if that's all that's given" do
		object = create_object(:state => "CA")
		assert_equal object.location, "CA"
	end

	test "should use None as location when no location, city or state given" do
		object = create_object
		assert_equal object.location, "None"
	end

end

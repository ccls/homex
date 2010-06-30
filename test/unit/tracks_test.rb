require File.dirname(__FILE__) + '/../test_helper'

class TrackTest < ActiveSupport::TestCase

	assert_should_initially_belong_to(:trackable)

	test "should create track" do
		assert_difference 'Track.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require trackable_id" do
		assert_no_difference 'Track.count' do
			object = create_object(:trackable_id => nil)
			assert object.errors.on(:trackable_id)
		end
	end

	test "should require trackable_type" do
		#	kinda challenging to override the _type with 
		#	Factory girl apparently
		assert_no_difference 'Track.count' do
			object = Factory.build(:track)
			object.trackable_type = nil
			object.save
			assert object.errors.on(:trackable_type)
		end
	end

	test "should require unique time scoped by trackable" do
		se = create_object
		assert_no_difference 'Track.count' do
			object = create_object(
				:trackable => se.trackable,
				:time      => se.time
			)
			#	errors on time NOT package_id
			assert object.errors.on(:time)
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

protected

	def create_object(options = {})
		record = Factory.build(:track,options)
		record.save
		record
	end

end

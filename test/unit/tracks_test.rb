require File.dirname(__FILE__) + '/../test_helper'

class TrackTest < ActiveSupport::TestCase

	assert_should_initially_belong_to(:trackable)

	test "should create track" do
		assert_difference 'Track.count' do
			track = create_track
			assert !track.new_record?, 
				"#{track.errors.full_messages.to_sentence}"
		end
	end

	test "should require trackable_id" do
		assert_no_difference 'Track.count' do
			track = create_track(:trackable_id => nil)
			assert track.errors.on(:trackable_id)
		end
	end

	test "should require trackable_type" do
		#	kinda challenging to override the _type with 
		#	Factory girl apparently
		assert_no_difference 'Track.count' do
			track = Factory.build(:track)
			track.trackable_type = nil
			track.save
			assert track.errors.on(:trackable_type)
		end
	end

	test "should require unique time scoped by trackable" do
		se = create_track
		assert_no_difference 'Track.count' do
			track = create_track(
				:trackable => se.trackable,
				:time      => se.time
			)
			#	errors on time NOT package_id
			assert track.errors.on(:time)
		end
	end

	test "should combine city and state into location" do
		track = create_track(
			:city => "Berkeley", :state => "CA")
		assert_equal track.location, "Berkeley, CA"
	end

	test "should use just city in location if that's all that's given" do
		track = create_track(:city => "Berkeley")
		assert_equal track.location, "Berkeley"
	end

	test "should use just state in location if that's all that's given" do
		track = create_track(:state => "CA")
		assert_equal track.location, "CA"
	end

	test "should use None as location when no location, city or state given" do
		track = create_track
		assert_equal track.location, "None"
	end

protected

	def create_track(options = {})
		record = Factory.build(:track,options)
		record.save
		record
	end
	alias_method :create_object, :create_track

end

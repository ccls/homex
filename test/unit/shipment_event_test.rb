require File.dirname(__FILE__) + '/../test_helper'

class ShipmentEventTest < ActiveSupport::TestCase

#	test "should create shipment_event" do
#		assert_difference 'ShipmentEvent.count' do
#			shipment_event = create_shipment_event
#			assert !shipment_event.new_record?, 
#				"#{shipment_event.errors.full_messages.to_sentence}"
#		end
#	end
#
#	test "should require package_id" do
#		assert_no_difference 'ShipmentEvent.count' do
#			shipment_event = create_shipment_event(:package_id => nil)
#			assert shipment_event.errors.on(:package_id)
#		end
#	end
#
#	test "should require unique time scoped by package_id" do
#		se = create_shipment_event
#		assert_no_difference 'ShipmentEvent.count' do
#			shipment_event = create_shipment_event(
#				:package_id => se.package_id,
#				:time       => se.time
#			)
#			#	errors on time NOT package_id
#			assert shipment_event.errors.on(:time)
#		end
#	end
#
#	test "should combine city and state into location" do
#		shipment_event = create_shipment_event(
#			:city => "Berkeley", :state => "CA")
#		assert_equal shipment_event.location, "Berkeley, CA"
#	end
#
#	test "should use just city in location if that's all that's given" do
#		shipment_event = create_shipment_event(:city => "Berkeley")
#		assert_equal shipment_event.location, "Berkeley"
#	end
#
#	test "should use just state in location if that's all that's given" do
#		shipment_event = create_shipment_event(:state => "CA")
#		assert_equal shipment_event.location, "CA"
#	end
#
#	test "should use None as location when no location, city or state given" do
#		shipment_event = create_shipment_event
#		assert_equal shipment_event.location, "None"
#	end
#
#	test "should belong to package" do
#		shipment_event = create_shipment_event
#		assert_not_nil shipment_event.package
#	end
#
#protected
#
#	def create_shipment_event(options = {})
#		record = Factory.build(:shipment_event,options)
#		record.save
#		record
#	end

end

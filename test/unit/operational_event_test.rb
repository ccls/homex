require File.dirname(__FILE__) + '/../test_helper'

class OperationalEventTest < ActiveSupport::TestCase

#	assert_should_initially_belong_to(:operational_event_type,:subject)
#	assert_requires_valid_associations(:operational_event_type,:subject)
	assert_should_belong_to(:enrollment)
#	assert_requires_valid_associations(:operational_event_type)
	assert_should_initially_belong_to(:operational_event_type)
	assert_requires_valid_associations(:operational_event_type)

	test "should create operational_event" do
		assert_difference 'OperationalEvent.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	#	description is not required so ...
	test "should return description as to_s if not nil" do
		object = create_object(:description => 'testing')
		assert_equal object.description, "#{object}"
	end

	test "should return NOT description as to_s if nil" do
		object = create_object
		assert_not_equal object.description, "#{object}"
	end

	test "should order by type ASC" do
		oe1 = create_object(:operational_event_type => Factory(
			:operational_event_type,:description => 'MMMM'))
		oe2 = create_object(:operational_event_type => Factory(
			:operational_event_type,:description => 'AAAA'))
		oe3 = create_object(:operational_event_type => Factory(
			:operational_event_type,:description => 'ZZZZ'))
		events = OperationalEvent.search(:order => 'type',:dir => 'asc')
		assert_equal events, [oe2,oe1,oe3]
	end

	test "should order by type DESC" do
		oe1 = create_object(:operational_event_type => Factory(
			:operational_event_type,:description => 'MMMM'))
		oe2 = create_object(:operational_event_type => Factory(
			:operational_event_type,:description => 'AAAA'))
		oe3 = create_object(:operational_event_type => Factory(
			:operational_event_type,:description => 'ZZZZ'))
		events = OperationalEvent.search(:order => 'type',:dir => 'desc')
		assert_equal events, [oe3,oe1,oe2]
	end

	test "should order by type and DESC as default dir" do
		oe1 = create_object(:operational_event_type => Factory(
			:operational_event_type,:description => 'MMMM'))
		oe2 = create_object(:operational_event_type => Factory(
			:operational_event_type,:description => 'AAAA'))
		oe3 = create_object(:operational_event_type => Factory(
			:operational_event_type,:description => 'ZZZZ'))
		events = OperationalEvent.search(:order => 'type')
		assert_equal events, [oe3,oe1,oe2]
	end

	test "should order by description ASC" do
		oe1 = create_object(:description => 'M')
		oe2 = create_object(:description => 'A')
		oe3 = create_object(:description => 'Z')
		events = OperationalEvent.search(:order => 'description',:dir => 'asc')
		assert_equal events, [oe2,oe1,oe3]
	end

	test "should order by description DESC" do
		oe1 = create_object(:description => 'M')
		oe2 = create_object(:description => 'A')
		oe3 = create_object(:description => 'Z')
		events = OperationalEvent.search(:order => 'description',:dir => 'desc')
		assert_equal events, [oe3,oe1,oe2]
	end

	test "should order by description and DESC as default dir" do
		oe1 = create_object(:description => 'M')
		oe2 = create_object(:description => 'A')
		oe3 = create_object(:description => 'Z')
		events = OperationalEvent.search(:order => 'description')
		assert_equal events, [oe3,oe1,oe2]
	end

	test "should order by occurred_on ASC" do
		oe1 = create_object(:occurred_on => Chronic.parse('last month'))
		oe2 = create_object(:occurred_on => Chronic.parse('last year'))
		oe3 = create_object(:occurred_on => Chronic.parse('last week'))
		events = OperationalEvent.search(:order => 'occurred_on',:dir => 'asc')
		assert_equal events, [oe2,oe1,oe3]
	end

	test "should order by occurred_on DESC" do
		oe1 = create_object(:occurred_on => Chronic.parse('last month'))
		oe2 = create_object(:occurred_on => Chronic.parse('last year'))
		oe3 = create_object(:occurred_on => Chronic.parse('last week'))
		events = OperationalEvent.search(:order => 'occurred_on',:dir => 'desc')
		assert_equal events, [oe3,oe1,oe2]
	end

	test "should order by occurred_on and DESC as default dir" do
		oe1 = create_object(:occurred_on => Chronic.parse('last month'))
		oe2 = create_object(:occurred_on => Chronic.parse('last year'))
		oe3 = create_object(:occurred_on => Chronic.parse('last week'))
		events = OperationalEvent.search(:order => 'occurred_on')
		assert_equal events, [oe3,oe1,oe2]
	end

	test "should order by occurred_on DESC as defaults" do
		oe1 = create_object(:occurred_on => Chronic.parse('last month'))
		oe2 = create_object(:occurred_on => Chronic.parse('last year'))
		oe3 = create_object(:occurred_on => Chronic.parse('last week'))
		events = OperationalEvent.search()
		assert_equal events, [oe3,oe1,oe2]
	end

	test "should ignore invalid order" do
		oe1 = create_object(:occurred_on => Chronic.parse('last month'))
		oe2 = create_object(:occurred_on => Chronic.parse('last year'))
		oe3 = create_object(:occurred_on => Chronic.parse('last week'))
		events = OperationalEvent.search(:order => 'iambogus')
		assert_equal events, [oe3,oe1,oe2]
	end

	test "should ignore invalid dir" do
		oe1 = create_object(:occurred_on => Chronic.parse('last month'))
		oe2 = create_object(:occurred_on => Chronic.parse('last year'))
		oe3 = create_object(:occurred_on => Chronic.parse('last week'))
		events = OperationalEvent.search(:order => 'occurred_on',
			:dir => 'iambogus')
		assert_equal events, [oe3,oe1,oe2]
	end

	test "should ignore valid dir without order" do
		oe1 = create_object(:occurred_on => Chronic.parse('last month'))
		oe2 = create_object(:occurred_on => Chronic.parse('last year'))
		oe3 = create_object(:occurred_on => Chronic.parse('last week'))
		events = OperationalEvent.search(:dir => 'ASC')
		assert_equal events, [oe3,oe1,oe2]
	end

protected

	def create_object(options = {})
		record = Factory.build(:operational_event,options)
		record.save
		record
	end

end

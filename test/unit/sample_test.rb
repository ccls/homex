require File.dirname(__FILE__) + '/../test_helper'

class SampleTest < ActiveSupport::TestCase

	test "should create sample" do
		assert_difference 'Sample.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should default order_no to 1" do
		object = create_object
		assert_equal 1, object.order_no
	end

	test "should default aliquot_or_sample_on_receipt to 'Sample'" do
		object = create_object
		assert_equal 'Sample', object.aliquot_or_sample_on_receipt
	end

	test "should require valid subject_id" do
		assert_no_difference 'Sample.count' do
			object = create_object(:subject_id => 0)
			assert object.errors.on(:subject)
		end
	end

	test "should require valid unit_id" do
		assert_no_difference 'Sample.count' do
			object = create_object(:unit_id => 0)
			assert object.errors.on(:unit)
		end
	end

	test "should require subject_id" do
		assert_no_difference 'Sample.count' do
			object = create_object(:subject_id => nil)
			assert object.errors.on(:subject)
		end
	end

	test "should require unit_id" do
		assert_no_difference 'Sample.count' do
			object = create_object(:unit_id => nil)
			assert object.errors.on(:unit)
		end
	end

	test "should belong to aliquot_sample_format" do
		object = create_object
		assert_nil object.aliquot_sample_format
		object.aliquot_sample_format = Factory(:aliquot_sample_format)
		assert_not_nil object.aliquot_sample_format
	end

	test "should belong to sample_subtype" do
		object = create_object
		assert_nil object.sample_subtype
		object.sample_subtype = Factory(:sample_subtype)
		assert_not_nil object.sample_subtype
	end

	test "should initially belong to subject" do
		object = create_object
		assert_not_nil object.subject
	end

	test "should initially belong to unit" do
		object = create_object
		assert_not_nil object.unit
	end

#	somehow

	test "should belong to organization" do
#		object = create_object
#		assert_nil object.organization
#		object.organization = Factory(:organization)
#		assert_not_nil object.organization

#	TODO

		#	this is not clear in my UML diagram

		pending
	end

	test "should have many aliquots" do
		object = create_object
		assert_equal 0, object.aliquots.length
		Factory(:aliquot, :sample_id => object.id)
		assert_equal 1, object.reload.aliquots.length
		Factory(:aliquot, :sample_id => object.id)
		assert_equal 2, object.reload.aliquots.length
	end

	test "should have and belong to many projects" do
		object = create_object
		assert_equal 0, object.projects.length
		object.projects << Factory(:project)
		assert_equal 1, object.reload.projects.length
		object.projects << Factory(:project)
		assert_equal 2, object.reload.projects.length
	end

protected

	def create_object(options = {})
		record = Factory.build(:sample,options)
		record.save
		record
	end

end

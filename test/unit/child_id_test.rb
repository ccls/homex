require File.dirname(__FILE__) + '/../test_helper'

class ChildIdTest < ActiveSupport::TestCase

	test "should create child_id" do
		assert_difference 'ChildId.count' do
			child_id = create_child_id
			assert !child_id.new_record?, 
				"#{child_id.errors.full_messages.to_sentence}"
		end
	end

#
#	subject uses accepts_attributes_for :child_id
#	so the child_id can't require subject_id on create
#	or this test fails.
#
	test "should require subject_id on update" do
		assert_difference 'ChildId.count', 1 do
			child_id = create_child_id
			child_id.reload.update_attributes(:childid => 1)
			assert child_id.errors.on(:subject_id)
		end
	end

	test "should belong to subject" do
		child_id = create_child_id
		assert_nil child_id.subject
		child_id.subject = Factory(:subject)
		assert_not_nil child_id.subject
	end


protected

	def create_child_id(options = {})
		record = Factory.build(:child_id,options)
		record.save
		record
	end

end

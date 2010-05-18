require File.dirname(__FILE__) + '/../test_helper'

class SubjectTypeTest < ActiveSupport::TestCase

	test "should create subject_type" do
		assert_difference 'SubjectType.count' do
			subject_type = create_subject_type
			assert !subject_type.new_record?, 
				"#{subject_type.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'SubjectType.count' do
			subject_type = create_subject_type(:description => nil)
			assert subject_type.errors.on(:description)
		end
	end

#	test "should require 4 char description" do
#		assert_no_difference 'SubjectType.count' do
#			subject_type = create_subject_type(:description => 'Hey')
#			assert subject_type.errors.on(:description)
#		end
#	end

	test "should require unique description" do
		st = create_subject_type
		assert_no_difference 'SubjectType.count' do
			subject_type = create_subject_type(
				:description => st.description)
			assert subject_type.errors.on(:description)
		end
	end

	test "should have many subjects" do
		subject_type = create_subject_type
		assert_equal 0, subject_type.subjects.length
		Factory(:subject, :subject_type_id => subject_type.id)
		assert_equal 1, subject_type.reload.subjects.length
		Factory(:subject, :subject_type_id => subject_type.id)
		assert_equal 2, subject_type.reload.subjects.length
	end

protected

	def create_subject_type(options = {})
		record = Factory.build(:subject_type,options)
		record.save
		record
	end

end

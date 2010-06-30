require File.dirname(__FILE__) + '/../test_helper'

class InterviewTest < ActiveSupport::TestCase

	test "should create interview" do
		assert_difference 'Interview.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should NOT require address_id" do
		assert_difference('Interview.count',1) do
			object = create_object(:address_id => nil)
			assert !object.errors.on(:address)
		end
	end

	test "should NOT require interviewer_id" do
		assert_difference('Interview.count',1) do
			object = create_object(:interviewer_id => nil)
			assert !object.errors.on(:interviewer)
		end
	end

	test "should NOT require interview_version_id" do
		assert_difference('Interview.count',1) do
			object = create_object(:interview_version_id => nil)
			assert !object.errors.on(:interview_version_id)
		end
	end

	test "should NOT require interview_method_id" do
		assert_difference('Interview.count',1) do
			object = create_object(:interview_method_id => nil)
			assert !object.errors.on(:interview_method_id)
		end
	end

	test "should NOT require language_id" do
		assert_difference('Interview.count',1) do
			object = create_object(:language_id => nil)
			assert !object.errors.on(:language_id)
		end
	end

	test "should NOT require identifier_id" do
		assert_difference('Interview.count',1) do
			object = create_object(:identifier_id => nil)
			assert !object.errors.on(:identifier_id)
		end
	end


	test "should NOT require valid address_id" do
		assert_difference('Interview.count',1) do
			object = create_object(:address_id => 0)
			assert !object.errors.on(:address)
		end
	end

	test "should NOT require valid interviewer_id" do
		assert_difference('Interview.count',1) do
			object = create_object(:interviewer_id => 0)
			assert !object.errors.on(:interviewer)
		end
	end

	test "should NOT require valid interview_version_id" do
		assert_difference('Interview.count',1) do
			object = create_object(:interview_version_id => 0)
			assert !object.errors.on(:interview_version_id)
		end
	end

	test "should NOT require valid interview_method_id" do
		assert_difference('Interview.count',1) do
			object = create_object(:interview_method_id => 0)
			assert !object.errors.on(:interview_method_id)
		end
	end

	test "should NOT require valid language_id" do
		assert_difference('Interview.count',1) do
			object = create_object(:language_id => 0)
			assert !object.errors.on(:language_id)
		end
	end

	test "should NOT require valid identifier_id" do
		assert_difference('Interview.count',1) do
			object = create_object(:identifier_id => 0)
			assert !object.errors.on(:identifier_id)
		end
	end

	test "should belong to an address" do
		object = create_object
		assert_nil object.address
		object.address = Factory(:address)
		assert_not_nil object.address
	end

	test "should belong to an interviewer" do
		object = create_object
		assert_nil object.interviewer
		object.interviewer = Factory(:person)
		assert_not_nil object.interviewer
		assert object.interviewer.is_a?(Person)
	end

	test "should belong to an interview_version" do
		object = create_object
		assert_nil object.interview_version
		object.interview_version = Factory(:interview_version)
		assert_not_nil object.interview_version
	end

	test "should belong to an interview_method" do
		object = create_object
		assert_nil object.interview_method
		object.interview_method = Factory(:interview_method)
		assert_not_nil object.interview_method
	end

	test "should belong to a language" do
		object = create_object
		assert_nil object.language
		object.language = Factory(:language)
		assert_not_nil object.language
	end

	test "should belong to an identifier" do
		object = create_object
		assert_nil object.identifier
		object.identifier = Factory(:identifier)
		assert_not_nil object.identifier
	end

protected

	def create_object(options = {})
		record = Factory.build(:interview,options)
		record.save
		record
	end

end

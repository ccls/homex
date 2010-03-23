require File.dirname(__FILE__) + '/../test_helper'

class ResponseTest < ActiveSupport::TestCase

	test "should create response" do
		assert_difference 'Response.count' do
			response = create_response
			assert !response.new_record?, 
				"#{response.errors.full_messages.to_sentence}"
		end
	end

	test "should require response_set_id" do
		assert_no_difference 'Response.count' do
			response = create_response(:response_set_id => nil)
			assert response.errors.on(:response_set_id)
		end
	end

	test "should require question_id" do
		assert_no_difference 'Response.count' do
			response = create_response(:question_id => nil)
			assert response.errors.on(:question_id)
		end
	end

	test "should require answer_id" do
		assert_no_difference 'Response.count' do
			response = create_response(:answer_id => nil)
			assert response.errors.on(:answer_id)
		end
	end

	test "should belong to a response_set" do
		response = create_response
		assert_not_nil response.response_set
	end

	test "should return q_and_a_codes for response_class string" do
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => 'string' },
			:response => { :string_value => "xyz" }
		)
		assert_equal ["abc","xyz"], response.q_and_a_codes
	end

	test "should return q_and_a_codes for response_class answer" do
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :data_export_identifier => "xyz" }
		)
		assert_equal ["abc","xyz"], response.q_and_a_codes
	end


protected

	def create_response(options = {})
		record = Factory.build(:response,options)
		record.save
		record
	end

end

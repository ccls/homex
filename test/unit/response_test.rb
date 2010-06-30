require File.dirname(__FILE__) + '/../test_helper'

class ResponseTest < ActiveSupport::TestCase

	assert_should_initially_belong_to(:response_set)

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

	test "should raise error on q_and_a_codes with invalid response_class" do
		#	This is unlikely to happen in reality
		#	as all of this is part of the gem.
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => '' },
			:response => { :string_value => "xyz" }
		)
		assert_raise(Response::InvalidResponseClass){
			response.q_and_a_codes
		}
	end

	test "should return q_and_a_codes for response_class integer" do
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => 'integer' },
			:response => { :integer_value => 1942 }
		)
		assert_equal ["abc",1942], response.q_and_a_codes
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
			:answer   => { 
				:data_export_identifier => "xyz",
				:response_class => 'answer' 
			}
		)
		assert_equal ["abc","xyz"], response.q_and_a_codes
	end

	test "should raise error on q_and_a_codes_and_text with invalid response_class" do
		#	This is unlikely to happen in reality
		#	as all of this is part of the gem.
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => '' },
			:response => { :string_value => "xyz" }
		)
		assert_raise(Response::InvalidResponseClass){
			response.q_and_a_codes_and_text
		}
	end

	test "should return q_and_a_codes_and_text for response_class integer" do
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => 'integer' },
			:response => { :integer_value => 1942 }
		)
		assert_equal response.q_and_a_codes_and_text,
			Hash['abc'=>{:a_code => 1942, :a_text => 1942, 
			:q_text => Factory.attributes_for(:question)[:text]}]
	end

	test "should return q_and_a_codes_and_text for response_class string" do
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => 'string' },
			:response => { :string_value => "xyz" }
		)
		assert_equal response.q_and_a_codes_and_text,
			Hash['abc'=>{:a_code => 'xyz', :a_text => 'xyz', 
			:q_text => Factory.attributes_for(:question)[:text]}]
	end

	test "should return q_and_a_codes_and_text for response_class answer" do
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { 
				:data_export_identifier => "xyz",
				:response_class => 'answer' 
			}
		)
		assert_equal response.q_and_a_codes_and_text,
			Hash['abc'=>{:a_code => 'xyz', 
			:a_text => Factory.attributes_for(:answer)[:text],
			:q_text => Factory.attributes_for(:question)[:text]}]
	end

protected

	def create_response(options = {})
		record = Factory.build(:response,options)
		record.save
		record
	end
	alias_method :create_object, :create_response

end

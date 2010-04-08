require File.dirname(__FILE__) + '/../test_helper'

class ResponseSetTest < ActiveSupport::TestCase

	test "should create response_set" do
		assert_difference 'ResponseSet.count' do
			response_set = create_response_set
			assert !response_set.new_record?, 
				"#{response_set.errors.full_messages.to_sentence}"
		end
	end

	test "should require survey_id" do
		assert_no_difference 'ResponseSet.count' do
			response_set = create_response_set(:survey_id => nil)
			assert response_set.errors.on(:survey_id)
		end
	end

	test "should require unique access_code" do
		ResponseSet.stubs(:find_by_access_code).returns(nil)
		rs = create_response_set
		assert_no_difference 'ResponseSet.count' do
			response_set = Factory.build(:response_set)
			assert_not_nil response_set.access_code
			response_set.access_code = rs.access_code
			response_set.save
			assert response_set.errors.on(:access_code)
		end
	end

	test "should replace non unique access_code" do
		rs = create_response_set
		assert_difference 'ResponseSet.count', 1 do
			response_set = Factory.build(:response_set)
			assert_not_nil response_set.access_code
			ac1 = response_set.access_code
			response_set.access_code = rs.access_code
			response_set.save
			ac2 = response_set.access_code
			assert_not_equal ac1, ac2
		end
	end

	test "should initially belong to a survey" do
		response_set = create_response_set
		assert_not_nil response_set.survey
	end

	test "should belong to a user" do
		response_set = create_response_set
		assert_nil response_set.user
		response_set.user = Factory(:user)
		assert_not_nil response_set.user
	end

	test "should initially belong to a subject" do
		response_set = create_response_set
		assert_not_nil response_set.reload.subject
		assert_equal 1, response_set.subject.response_sets_count
	end

	#	This works, but the responses' questions and answers
	#	are all pointing in different directions.
	test "should have many responses" do
		response_set = create_response_set
		assert_equal 0, response_set.responses.length
		Factory(:response, :response_set_id => response_set.id)
		assert_equal 1, response_set.reload.responses.length
		Factory(:response, :response_set_id => response_set.id)
		assert_equal 2, response_set.reload.responses.length
	end

	test "should return codes for response_set" do
		r1 = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => 'string' },
			:response => { :string_value => "def" }
		)
		r2 = full_response(
			:response => { :response_set => r1.response_set },
			:question => { :data_export_identifier => "ghi" },
			:answer   => { :data_export_identifier => "jkl" }
		)
		assert_equal [["abc","def"],["ghi","jkl"]], 
			r1.response_set.reload.q_and_a_codes
		assert_equal Hash[*[["abc","def"],["ghi","jkl"]].flatten],
			r1.response_set.reload.q_and_a_codes_as_attributes

		assert_equal r1.response_set.reload.codes_and_text,
			Hash['abc'=>{
					:a_code => 'def',
					:a_text => 'def',
					:q_text => r1.question.text
				},
				'ghi'=>{
					:a_code => 'jkl',
					:a_text => Factory.attributes_for(:answer)[:text],
					:q_text => r2.question.text
			}]
	end

	test "should merge matching surveys into single HER" do
		assert_difference( 'Survey.count', 1 ) {
		assert_difference( 'SurveySection.count', 1 ) {
		assert_difference( 'Question.count', 4 ) {
		assert_difference( 'Answer.count', 4 ) {
		assert_difference( 'ResponseSet.count', 2 ) {
		assert_difference( 'Response.count', 8 ) {
			@rs1 = full_response_set(
				:response_set => { :subject_id => 42 })
			@rs2 = full_response_set(:survey => @rs1.survey,
				:response_set => { :subject_id => 42 })
		} } } } } }

		qa1 = @rs1.reload.q_and_a_codes_as_attributes
		qa2 = @rs2.reload.q_and_a_codes_as_attributes

		assert (@rs1.reload.diff(@rs2.reload)).blank?
		assert @rs1.is_the_same_as?(@rs2)
		assert_equal qa1, qa2
		assert_difference( 'HomeExposureResponse.count') {
			her = @rs1.to_her
			assert_equal 42, her.subject_id
		}
	end

	test "should destroy responses on set destroy" do
		assert_difference( 'Survey.count', 1 ) {
		assert_difference( 'SurveySection.count', 1 ) {
		assert_difference( 'Question.count', 4 ) {
		assert_difference( 'Answer.count', 4 ) {
		assert_difference( 'ResponseSet.count', 2 ) {
		assert_difference( 'Response.count', 8 ) {
			@rs1 = full_response_set(
				:response_set => { :subject_id => 42 })
			@rs2 = full_response_set(:survey => @rs1.survey,
				:response_set => { :subject_id => 42 })
		} } } } } }

		assert_difference( 'Survey.count', 0 ) {
		assert_difference( 'SurveySection.count', 0 ) {
		assert_difference( 'Question.count', 0 ) {
		assert_difference( 'Answer.count', 0 ) {
		assert_difference( 'ResponseSet.count', -1 ) {
		assert_difference( 'Response.count', -4 ) {
			@rs1.reload.destroy
		} } } } } }
	end

protected

	def create_response_set(options = {})
		record = Factory.build(:response_set,options)
		record.save
		record
	end

end

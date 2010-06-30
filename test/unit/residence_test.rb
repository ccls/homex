require File.dirname(__FILE__) + '/../test_helper'

class ResidenceTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:address)
	assert_should_initially_belong_to(:address)

	test "should create residence" do
		assert_difference 'Residence.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should NOT destroy address on destroy" do
		object = create_object
		assert_difference('Residence.count', -1) {
		assert_difference('Address.count',0) {
			object.destroy
		} }
	end

protected

	def create_object(options = {})
		record = Factory.build(:residence,options)
		record.save
		record
	end

end

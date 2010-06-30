require File.dirname(__FILE__) + '/../test_helper'

class ResidenceTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:address)

	test "should create residence" do
		assert_difference 'Residence.count' do
			residence = create_residence
			assert !residence.new_record?, 
				"#{residence.errors.full_messages.to_sentence}"
		end
	end

	test "should initially belong to an address" do
		residence = create_residence
		assert_not_nil residence.address
	end

	test "should NOT destroy address on destroy" do
		residence = create_residence
		assert_difference('Residence.count', -1) {
		assert_difference('Address.count',0) {
			residence.destroy
		} }
	end

protected

	def create_residence(options = {})
		record = Factory.build(:residence,options)
		record.save
		record
	end
	alias_method :create_object, :create_residence

end

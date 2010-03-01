require File.dirname(__FILE__) + '/../test_helper'

class ResidenceTest < ActiveSupport::TestCase

	test "should create residence" do
		assert_difference 'Residence.count' do
			residence = create_residence
			assert !residence.new_record?, "#{residence.errors.full_messages.to_sentence}"
		end
	end

	test "should require address_id" do
		assert_no_difference 'Residence.count' do
			residence = create_residence(:address_id => nil)
			assert residence.errors.on(:address_id)
		end
	end

	test "should require subject_id" do
		assert_no_difference 'Residence.count' do
			residence = create_residence(:subject_id => nil)
			assert residence.errors.on(:subject_id)
		end
	end

	test "should belong to an address" do
		residence = create_residence
#		assert_nil residence.address
#		residence.address = Factory(:address)
		assert_not_nil residence.address
	end

	test "should belong to a subject" do
		residence = create_residence
#		assert_nil residence.subject
#		residence.subject = Factory(:subject)
		assert_not_nil residence.subject
	end

protected

	def create_residence(options = {})
		record = Factory.build(:residence,options)
		record.save
		record
	end

end

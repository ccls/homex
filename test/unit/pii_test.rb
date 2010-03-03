require File.dirname(__FILE__) + '/../test_helper'

class PiiTest < ActiveSupport::TestCase

	test "should create pii" do
		assert_difference 'Pii.count' do
			pii = create_pii
			assert !pii.new_record?, 
				"#{pii.errors.full_messages.to_sentence}"
		end
	end

	test "should require subject_id" do
		assert_no_difference 'Pii.count' do
			pii = create_pii(:subject_id => nil)
			assert pii.errors.on(:subject_id)
		end
	end

	test "should require ssn" do
		assert_no_difference 'Pii.count' do
			pii = create_pii(:ssn => nil)
			assert pii.errors.on(:ssn)
		end
	end

	test "should require unique ssn" do
		p = create_pii
		assert_no_difference 'Pii.count' do
			pii = create_pii(:ssn => p.ssn)
			assert pii.errors.on(:ssn)
		end
	end

	test "should require properly formatted ssn a" do
		%w( 12345678X 12345678 12-34-56-789 ).each do |invalid_ssn|
			assert_no_difference 'Pii.count' do
				pii = create_pii(:ssn => invalid_ssn)
				assert pii.errors.on(:ssn)
			end
		end
	end

	test "should require state_id_no" do
		assert_no_difference 'Pii.count' do
			pii = create_pii(:state_id_no => nil)
			assert pii.errors.on(:state_id_no)
		end
	end

	test "should require unique state_id_no" do
		p = create_pii
		assert_no_difference 'Pii.count' do
			pii = create_pii(:state_id_no => p.state_id_no)
			assert pii.errors.on(:state_id_no)
		end
	end

	test "should belong to subject" do
		pii = create_pii
		assert_not_nil pii.subject
	end


protected

	def create_pii(options = {})
		record = Factory.build(:pii,options)
		record.save
		record
	end

end

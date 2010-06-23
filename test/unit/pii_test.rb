require File.dirname(__FILE__) + '/../test_helper'

class PiiTest < ActiveSupport::TestCase

	test "should create pii" do
		assert_difference 'Pii.count' do
			pii = create_pii
			assert !pii.new_record?, 
				"#{pii.errors.full_messages.to_sentence}"
		end
	end

	test "should create pii with all numeric ssn" do
		assert_difference 'Pii.count' do
			pii = create_pii(:ssn => 987654321)
			assert !pii.new_record?, 
				"#{pii.errors.full_messages.to_sentence}"
			assert_equal '987654321', pii.reload.ssn
		end
	end

	test "should create pii with string all numeric ssn" do
		assert_difference 'Pii.count' do
			pii = create_pii(:ssn => '987654321')
			assert !pii.new_record?, 
				"#{pii.errors.full_messages.to_sentence}"
			assert_equal '987654321', pii.reload.ssn
		end
	end

	test "should create pii with string standard format ssn" do
		assert_difference 'Pii.count' do
			pii = create_pii(:ssn => '987-65-4321')
			assert !pii.new_record?, 
				"#{pii.errors.full_messages.to_sentence}"
			assert_equal '987654321', pii.reload.ssn
		end
	end

	#
	#	subject uses accepts_attributes_for :pii
	#	so the pii can't require subject_id on create
	#	or this test fails.
	#
	test "should require subject_id on update" do
		assert_difference 'Pii.count', 1 do
			pii = create_pii
			pii.reload.update_attributes(:first_name => "New First Name")
			assert pii.errors.on(:subject)
		end
	end

	test "should require unique subject_id" do
		subject = Factory(:subject)
		create_pii(:subject => subject)
		assert_difference( 'Pii.count', 0 ) do
			pii = create_pii(:subject => subject)
			assert pii.errors.on(:subject_id)
		end
	end

	test "should require stype" do
		assert_no_difference 'Pii.count' do
			pii = create_pii(:stype => nil)
			assert pii.errors.on(:stype)
		end
	end

	test "should require orderno" do
		assert_no_difference 'Pii.count' do
			pii = create_pii(:orderno => nil)
			assert pii.errors.on(:orderno)
		end
	end

	test "should require 1 char orderno" do
		assert_no_difference 'Pii.count' do
			pii = create_pii(:orderno => '12')
			assert pii.errors.on(:orderno)
		end
	end

	test "should require 1 DIGIT orderno" do
		assert_no_difference 'Pii.count' do
			pii = create_pii(:orderno => 'A')
			assert pii.errors.on(:orderno)
		end
	end

	test "should require patid" do
		assert_no_difference 'Pii.count' do
			pii = create_pii(:patid => nil)
			assert pii.errors.on(:patid)
		end
	end

	test "should require unique patid, stype and orderno" do
		p = create_pii
		assert_no_difference 'Pii.count' do
			pii = create_pii({
				:patid => p.patid,
				:stype => p.stype,
				:orderno => p.orderno
			})
			assert pii.errors.on(:patid)
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

	test "should require 9 digits in ssn" do
		%w( 12345678X 12345678 1-34-56-789 ).each do |invalid_ssn|
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
		assert_nil pii.subject
		pii.subject = Factory(:subject)
		assert_not_nil pii.subject
	end

	test "should require properly formated email address" do
		pending
	end

protected

	def create_pii(options = {})
		record = Factory.build(:pii,options)
		record.save
		record
	end

end

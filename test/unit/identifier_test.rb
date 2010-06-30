require File.dirname(__FILE__) + '/../test_helper'

class IdentifierTest < ActiveSupport::TestCase

	assert_should_belong_to(:subject)

	test "should create identifier" do
		assert_difference 'Identifier.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	#
	#	subject uses accepts_attributes_for :child_id
	#	so the child_id can't require subject_id on create
	#	or this test fails.
	#
	test "should require subject_id on update" do
		assert_difference 'Identifier.count', 1 do
			object = create_object
			object.reload.update_attributes(:childid => 1)
			assert object.errors.on(:subject)
		end
	end

	test "should require unique subject_id" do
		subject = Factory(:subject)
		create_object(:subject => subject)
		assert_difference( 'Identifier.count', 0 ) do
			object = create_object(:subject => subject)
			assert object.errors.on(:subject_id)
		end
	end

	test "should require valid subject_id on update" do
		assert_difference( 'Identifier.count', 1 )do
			object = create_object(:subject_id => 0)
			object.reload.update_attributes(:childid => 1)
			assert object.errors.on(:subject)
		end
	end

	test "should require childid" do
		assert_difference('Identifier.count',0) do
			object = create_object(:childid => nil)
			assert object.errors.on(:childid)
		end
	end

	test "should require unique childid" do
		c = create_object
		assert_difference('Identifier.count',0) do
			object = create_object(:childid => c.childid)
			assert object.errors.on(:childid)
		end
	end

	test "should create with all numeric ssn" do
		assert_difference 'Identifier.count' do
			object = create_object(:ssn => 987654321)
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal '987654321', object.reload.ssn
		end
	end

	test "should create with string all numeric ssn" do
		assert_difference 'Identifier.count' do
			object = create_object(:ssn => '987654321')
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal '987654321', object.reload.ssn
		end
	end

	test "should create with string standard format ssn" do
		assert_difference 'Identifier.count' do
			object = create_object(:ssn => '987-65-4321')
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal '987654321', object.reload.ssn
		end
	end

	test "should require case_control_type" do
		assert_no_difference 'Identifier.count' do
			object = create_object(:case_control_type => nil)
			assert object.errors.on(:case_control_type)
		end
	end

	test "should require orderno" do
		assert_no_difference 'Identifier.count' do
			object = create_object(:orderno => nil)
			assert object.errors.on(:orderno)
		end
	end

#	test "should require 1 char orderno" do
#		assert_no_difference 'Identifier.count' do
#			object = create_object(:orderno => '12')
#			assert object.errors.on(:orderno)
#		end
#	end

#	test "should require 1 DIGIT orderno" do
#		assert_no_difference 'Identifier.count' do
#			object = create_object(:orderno => 'A')
#			assert object.errors.on(:orderno)
#		end
#	end

	test "should require patid" do
		assert_no_difference 'Identifier.count' do
			object = create_object(:patid => nil)
			assert object.errors.on(:patid)
		end
	end

	test "should require unique patid, case_control_type and orderno" do
#	still works without a subject and subject_type
#	test "should require unique studyid" do
		p = create_object
		assert_no_difference 'Identifier.count' do
			object = create_object({
				:patid => p.patid,
				:case_control_type => p.case_control_type,
				:orderno => p.orderno
			})
			assert object.errors.on(:patid)
		end
	end

	test "should require ssn" do
		assert_no_difference 'Identifier.count' do
			object = create_object(:ssn => nil)
			assert object.errors.on(:ssn)
		end
	end

	test "should require unique ssn" do
		p = create_object
		assert_no_difference 'Identifier.count' do
			object = create_object(:ssn => p.ssn)
			assert object.errors.on(:ssn)
		end
	end

	test "should require 9 digits in ssn" do
		%w( 12345678X 12345678 1-34-56-789 ).each do |invalid_ssn|
			assert_no_difference 'Identifier.count' do
				object = create_object(:ssn => invalid_ssn)
				assert object.errors.on(:ssn)
			end
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:identifier,options)
		record.save
		record
	end

end

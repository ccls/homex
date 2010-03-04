require File.dirname(__FILE__) + '/../test_helper'

class ExportTest < ActiveSupport::TestCase

	test "should create export" do
		assert_difference 'Export.count' do
			export = create_export
			assert !export.new_record?, 
				"#{export.errors.full_messages.to_sentence}"
		end
	end

	test "should require patid" do
		assert_no_difference 'Export.count' do
			export = create_export(:patid => nil)
			assert export.errors.on(:patid)
		end
	end

	test "should require unique patid" do
		e = create_export
		assert_no_difference 'Export.count' do
			export = create_export(:patid => e.patid)
			assert export.errors.on(:patid)
		end
	end

	test "should require childid" do
		assert_no_difference 'Export.count' do
			export = create_export(:childid => nil)
			assert export.errors.on(:childid)
		end
	end

	test "should require unique childid" do
		e = create_export
		assert_no_difference 'Export.count' do
			export = create_export(:childid => e.childid)
			assert export.errors.on(:childid)
		end
	end

protected

	def create_export(options = {})
		record = Factory.build(:export,options)
		record.save
		record
	end

end

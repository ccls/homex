require File.dirname(__FILE__) + '/../test_helper'

class ExportTest < ActiveSupport::TestCase

	test "should create export" do
		assert_difference 'Export.count' do
			export = create_export
			assert !export.new_record?, 
				"#{export.errors.full_messages.to_sentence}"
		end
	end

#	test "should require carrier" do
#		assert_no_difference 'Export.count' do
#			export = create_export(:carrier => nil)
#			assert export.errors.on(:carrier)
#		end
#	end

protected

	def create_export(options = {})
		record = Factory.build(:export,options)
		record.save
		record
	end

end

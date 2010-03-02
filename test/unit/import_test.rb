require File.dirname(__FILE__) + '/../test_helper'

class ImportTest < ActiveSupport::TestCase

	test "should create import" do
		assert_difference 'Import.count' do
			import = create_import
			assert !import.new_record?, 
				"#{import.errors.full_messages.to_sentence}"
		end
	end

#	test "should require carrier" do
#		assert_no_difference 'Import.count' do
#			import = create_import(:carrier => nil)
#			assert import.errors.on(:carrier)
#		end
#	end

protected

	def create_import(options = {})
		record = Factory.build(:import,options)
		record.save
		record
	end

end

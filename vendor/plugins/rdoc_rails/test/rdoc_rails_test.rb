require File.dirname(__FILE__) + '/test_helper'
require 'fileutils'

class RDocRailsTest < ActiveSupport::TestCase

#	test "should say hello" do
#		puts 'hello'
#	end

	test "should do something" do
		FileUtils.remove_dir("test/rdoc") if File.exists?("test/rdoc")
		Rake::Task[:rdoc_test].invoke
	end

end

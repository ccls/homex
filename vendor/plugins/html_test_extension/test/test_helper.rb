require 'rubygems'
require 'active_record'
require 'action_controller'
#require 'action_controller/test_case'
#require 'active_support/test_case'

#	The html_test plugin must be right next to this
#	OR already have its lib accessible.
$:.unshift "#{File.dirname(__FILE__)}/../../html_test/lib"
require File.dirname(__FILE__) + '/../init'


ActiveRecord::Base.establish_connection(
	:adapter => "sqlite3", :database => ":memory:")

def setup_db
	ActiveRecord::Schema.define(:version => 1) do
#		create_table :users do |t|
#			t.string :role_name
#		end
#		create_table :posts do |t|
#			t.references :user
#		end
	end
end

def teardown_db
	ActiveRecord::Base.connection.tables.each do |table|
		ActiveRecord::Base.connection.drop_table(table)
	end
end

class ActiveSupport::TestCase

end


#require 'rails_generator'	#	<- did this for cattr_accessor. DON'T
#	causes the ugly failures
#	Now that i've commented it out, I don't need it.
#	I don't quite get it.
#	cattr_accessor is still used in validator.
#
#	I don't know what I did or did not do, but rake test 
#	failures are UGLY and very unhelpful.
#	I blame html_test cause my code is very similar
#	to other plugins and they fail tests nicely.
#
#	validating does NOT add to the number of assertions
#	UNLESS it fails, then the validator asserts an error
#	so that it shows up.  So don't count the assertions
#	to see if there is a difference with and without
#	revalidate_all, because there won't be
#

require 'rubygems'
require 'active_record'
require 'action_controller'
#require 'action_controller/test_case'
#require 'active_support/test_case'

$:.unshift "#{File.dirname(__FILE__)}"
require 'application_controller'
#	The html_test plugin must be right next to this
#	OR already have its lib accessible.
$:.unshift "#{File.dirname(__FILE__)}/../../html_test/lib"
#	OR
$:.unshift "#{File.dirname(__FILE__)}/../../../peter/html_test/lib"
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

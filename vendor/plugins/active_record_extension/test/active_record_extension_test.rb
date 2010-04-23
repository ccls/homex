require 'test/unit'
require 'rubygems'
require 'active_record'
require 'active_support/test_case'

$:.unshift "#{File.dirname(__FILE__)}/../lib"
require "#{File.dirname(__FILE__)}/../rails/init"
#require 'active_record_extension'
#ActiveRecord::Base.class_eval { include ActiveRecordExtension }

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
	ActiveRecord::Schema.define(:version => 1) do
#		create_table :users do |t|
#			t.string :name
#			t.timestamps
#		end
		create_table :things do |t|
#			t.references :user
			t.string :name
			t.timestamps
		end
	end
end

#	no data is ever actually added so there is currently no need to create and destroy
#	the entire database for every test
setup_db

def teardown_db
	ActiveRecord::Base.connection.tables.each do |table|
		ActiveRecord::Base.connection.drop_table(table)
	end
end

def reset_db
	teardown_db
	setup_db
end

#class User < ActiveRecord::Base
#	has_many :things
#end

class Thing < ActiveRecord::Base
#	belongs_to :user
end

class ActiveRecordExtensionTest < ActiveSupport::TestCase

#	def setup
#		setup_db
#	end
#
#	def teardown
#		teardown_db
#	end

	test "should get table status" do
#		This is MySQL specific
#		puts Thing.table_status
	end

	test "should get next_id" do
#		This is MySQL specific
#		puts Thing.next_id
	end

	test "should ignore articles in name" do
		Thing.create(:name => "A Zebra")
		Thing.create(:name => "The Apple")
#	ignore_articles_in_order_by returns a MySQL snippet, invalid in sqlite3
#		things = Thing.find(:all, :order => Thing.ignore_articles_in_order_by('name'))
		reset_db
	end

	test "should untaint valid additional column given as symbol" do
		untainted_column = Thing.untaint_column('foobar', :additionals => :foobar)
		assert_equal 'foobar', untainted_column
	end

	test "should untaint valid additional column given as string" do
		untainted_column = Thing.untaint_column('foobar', :additionals => 'foobar')
		assert_equal 'foobar', untainted_column
	end

	test "should untaint valid additional column given as array" do
		untainted_column = Thing.untaint_column('foobar', :additionals => ['foobar'])
		assert_equal 'foobar', untainted_column
	end

	test "should untaint invalid column to given default :rails" do
		untainted_column = Thing.untaint_column('foobar',:default => :rails)
		assert_equal 'rails', untainted_column
	end

	test "should untaint invalid column to given default 'rails'" do
		untainted_column = Thing.untaint_column('foobar',:default => 'rails')
		assert_equal 'rails', untainted_column
	end

	test "should untaint invalid column to default id" do
		untainted_column = Thing.untaint_column('foobar')
		assert_equal 'id', untainted_column
	end

	test "should untaint empty column to default id" do
		untainted_column = Thing.untaint_column()
		assert_equal 'id', untainted_column
	end

	test "should untaint valid column thing.name" do
		untainted_column = Thing.untaint_column('name')
		assert_equal 'name', untainted_column
	end

	test "should untaint invalid direction 'up' to ASC" do
		untainted_direction = Thing.untaint_direction('up')
		assert_equal 'ASC', untainted_direction
	end

	test "should untaint invalid direction '' to ASC" do
		untainted_direction = Thing.untaint_direction('')
		assert_equal 'ASC', untainted_direction
	end

	test "should untaint invalid numeric direction to ASC" do
		untainted_direction = Thing.untaint_direction(42)
		assert_equal 'ASC', untainted_direction
	end

	test "should untaint direction ASC" do
		untainted_direction = Thing.untaint_direction('ASC')
		assert_equal 'ASC', untainted_direction
	end

	test "should untaint direction DESC" do
		untainted_direction = Thing.untaint_direction('DESC')
		assert_equal 'DESC', untainted_direction
	end

	test "should untaint direction asc" do
		untainted_direction = Thing.untaint_direction('asc')
		assert_equal 'ASC', untainted_direction
	end

	test "should untaint direction desc" do
		untainted_direction = Thing.untaint_direction('desc')
		assert_equal 'DESC', untainted_direction
	end

end

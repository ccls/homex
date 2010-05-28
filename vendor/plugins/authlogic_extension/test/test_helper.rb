require 'test/unit'
require 'rubygems'
require 'active_record'
require 'active_record/fixtures'
require 'action_controller'
require 'action_controller/test_case'
require 'active_support/test_case'
require 'authlogic'
require 'authlogic/test_case'
require File.dirname(__FILE__) + '/../init'

#	Don't output ALL of the database migrations 
#	for EVERY test
ActiveRecord::Schema.verbose = false

#	Don't know what this is, but without it
#	transactions don't work
ActiveRecord::Base.configurations = true

ActiveRecord::Base.establish_connection(
	:adapter => "sqlite3", 
	:database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
	create_table :users do |t|
		t.string :login
		t.string :email
		t.string :crypted_password
		t.string :password_salt
		t.string :persistence_token
		t.string :perishable_token
    t.timestamps
	end
	add_index :users, :login, :unique => true
	add_index :users, :email, :unique => true
end

class User < ActiveRecord::Base
	#	Some Authlogic BS requires that the db exists
	#	before running acts_as_authentic or it will
	#	just silently do nothing!
	acts_as_authentic 	#do |c|
#		c.maintain_sessions = false
#	end
end

class UserSession < Authlogic::Session::Base
end

class ActiveSupport::TestCase
	include ActiveRecord::TestFixtures
	self.use_transactional_fixtures = true

	@@count = 0
	setup    :activate_authlogic

	def create_user(options={})
		@@count += 1
		User.create!({
			:login    => "login#{@@count}",
			:email    => "login#{@@count}@example.com",
			:password => 'test',
			:password_confirmation => 'test'
		}.merge(options))
	end

end

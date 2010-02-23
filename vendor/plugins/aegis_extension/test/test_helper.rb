require 'test/unit'
require 'rubygems'
require 'active_record'
require 'action_controller'
require 'action_controller/test_case'
require 'active_support/test_case'
require 'aegis'
require File.dirname(__FILE__) + '/../init'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
	ActiveRecord::Schema.define(:version => 1) do
		create_table :users do |t|
			t.string :role_name
		end
		create_table :posts do |t|
			t.references :user
		end
	end
end

def teardown_db
	ActiveRecord::Base.connection.tables.each do |table|
		ActiveRecord::Base.connection.drop_table(table)
	end
end


class User < ActiveRecord::Base
	has_many :posts
	has_role :default => :user
	validates_role_name
end

class Post < ActiveRecord::Base
	belongs_to :user
end

class Permissions < Aegis::Permissions
	role :user
	role :moderator
	role :administrator, :default_permission => :allow
	permission :administrate do
	end
	permission :moderate do
		allow :moderator
	end
	permission :read_post do
		allow :everyone
	end
	permission :create_post do
		allow :user
		allow :moderator
	end
	permission :update_post, :destroy_post do |current_user,post|
		allow :user do
			current_user == post.user
		end
	end
end

class ActiveSupport::TestCase

	def active_user(options={})
		User.create(options)
	end

	def admin_user(options={})
		u = active_user(options.merge(:role_name => "administrator"))
		u
	end

	def login_as( user=nil )
		@request.session[:user_id] = case 
			when user.is_a?(Integer) then user
			when user.is_a?(String)  then user
			when user.is_a?(User)    then user.id
			else nil
		end
	end

end

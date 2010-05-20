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
	role :user, :position => 1
	role :moderator, :position => 2
	role :administrator, :default_permission => :allow, :position => 3
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

	permission :destroy_user do
	end
	permission :be_user do |current_user,target_user|
		#	MUST deny everyone first (includes admin)
		#	so that negative works.  "be user" is more of
		#	an absolute so an admin isn't someone else.
		deny :everyone
		allow :everyone do 
			current_user == target_user
		end
	end
end

class ActiveSupport::TestCase

	def active_user(options={})
		User.create(options)
	end

	def admin_user(options={})
		active_user(options.merge(:role_name => "administrator"))
	end

	def login_as( user=nil )
		@request.session[:user_id] = ( user.is_a?(User) ) ? user.id : user
	end

end

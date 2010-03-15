require 'test/unit'	#	<-- needed but not added by rails generator
require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require File.dirname(__FILE__) + '/../init'

ActiveRecord::Base.establish_connection(
	:adapter => "sqlite3", 
	:database => ":memory:")

def build_full_database_structure
	here = File.dirname(__FILE__)
	require 'rails_generator'
	require 'rails_generator/scripts/generate'
	Dir.glob(here + "/../db/migrate/*rb").each do |fn|
		File.delete(fn)
	end
	File.delete('my_log_file') if File.exists?('my_log_file')

	Dir.mkdir(here + "/../db") unless
		File.exists?(here + "/../db")
	Dir.mkdir(here + "/../db/migrate/") unless
		File.exists?(here + "/../db/migrate/")
	require 'ftools'
	File.copy(here + "/001_create_trackables.rb",
		here + "/../db/migrate/")

	Rails::Generator::Base.append_sources(
		Rails::Generator::PathSource.new(
			:trackable, here + "/../generators/"
	) )	#	needed to find generators
	Rails::Generator::Scripts::Generate.new.run(
		['track_migration'],{
		:destination => '.'	#	File.dirname(__FILE__)
	})
	sleep 1	#	otherwise end up with dup date error
	Rails::Generator::Scripts::Generate.new.run(
		['trackable_migration','Book'],{
		:destination => '.'	#	File.dirname(__FILE__)
	})
	sleep 1	#	otherwise end up with dup date error
	Rails::Generator::Scripts::Generate.new.run(
		['trackable_migration','Package'],{
		:destination => '.'	#	File.dirname(__FILE__)
	})
	#	Any destination other than '.' does not allow for 
	#	collision checking which is irritating!
	#	'Another migration is already named' checking 
	ActiveRecord::Base.logger = Logger.new('my_log_file')
end

def setup_db
	ActiveRecord::Migrator.migrate("db/migrate/",nil)
end

def teardown_db
	ActiveRecord::Migrator.migrate("db/migrate/",0)
end

class Track < ActiveRecord::Base
end
class Package < ActiveRecord::Base
	attr_accessible :name
	acts_as_trackable
end
class Book < ActiveRecord::Base
	acts_as_trackable
end

class ActiveSupport::TestCase

	def build_track(options = {})
		record = Track.new({
			:name => 'track name',
			:time => Time.now
		}.merge(options))
		record
	end

	def create_track(options={})
		record = build_track(options)
		record.save
		record
	end

	def create_book(options = {})
		record = Book.new({
			:tracking_number => '123'
		}.merge(options))
		record.save
		record
	end

end




build_full_database_structure()

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
#	require 'ftools'
	FileUtils.copy(here + "/001_create_pages.rb",
		here + "/../db/migrate/")

	Rails::Generator::Base.append_sources(
		Rails::Generator::PathSource.new(
			:translatable, here + "/../generators/"
	) )	#	needed to find generators
	Rails::Generator::Scripts::Generate.new.run(
		['acts_as_translatable','Page'],{
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

class Page < ActiveRecord::Base
	attr_accessible :path, :title, :body
	validates_uniqueness_of :path, :scope => :locale
	acts_as_translatable :this_is_a => :test,
		:locales => ['en', :es, :fr]
end

class ActiveSupport::TestCase

end

build_full_database_structure()

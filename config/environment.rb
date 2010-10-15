# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.10' unless defined? RAILS_GEM_VERSION

#ENV['RAILS_ENV'] ||= 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

#	This constant is used in the ucb_ccls_engine#Document
#	and other places like Amazon buckets
#	for controlling the path to documents.
RAILS_APP_NAME = 'homex'

Rails::Initializer.run do |config|

	config.gem 'jakewendt-ccls_engine',
		:lib    => 'ccls_engine',
		:source => 'http://rubygems.org'

	#	rails 3 requires i18n gem which will load
	#	a version incompatible with 2.3.8.
	#	It will generate several of ...
	#	The {{key}} interpolation syntax in I18n 
	#	messages is deprecated. Please use %{key} instead.
	#	This must be called early, or someone else will load a newer version.
	config.gem "i18n", :version => '=0.3.7'

	if RUBY_PLATFORM =~ /java/
		#	For functionality with rvm/jruby
		#	I expected to have to change database.yml for this but didn't
		config.gem 'activerecord-jdbcmysql-adapter',
			:lib => 'active_record/connection_adapters/jdbcmysql_adapter'

		config.gem 'jdbc-mysql', :lib => 'jdbc/mysql'
		#	Additional jruby specific jars required in the war
		config.gem 'jdbc-sqlite3', :lib => 'jdbc/sqlite3'
		config.gem 'jruby-openssl', :lib => 'openssl'
	else

		# If using mysql ...
		# On Mac OS X:
		#   sudo gem install mysql -- --with-mysql-dir=/usr/local/mysql
		# On Mac OS X Leopard:
		#   sudo env ARCHFLAGS="-arch i386" gem install mysql 
		#			-- --with-mysql-config=/usr/local/mysql/bin/mysql_config
		# ... however, I had to install the mysql gem like so ...
		#   sudo env ARCHFLAGS="-arch x86_64" gem install mysql 
		#			-- --with-mysql-config=/usr/local/mysql/bin/mysql_config

		config.gem 'mysql'
	end

	config.gem 'haml'      # Needed for Surveyor
	config.gem "chronic"   #		http://chronic.rubyforge.org/
	config.gem 'active_shipping'
	config.gem 'will_paginate'
	config.gem 'fastercsv'

	config.frameworks -= [ :active_resource ]

	# Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
	# Run "rake -D time" for a list of tasks for finding time zone names.
	config.time_zone = 'UTC'

end

YNDK = HashWithIndifferentAccess.new({
	:yes   => 1,
	:true  => 1,
	:no    => 2,
	:false => 2,
	:dk    => 999
}).freeze

#	Due to some flexibility mods to CalnetAuthenticated
#	User doesn't load until it is needed, 
#	which means that calnet_authenticated isn't called,
#	which means that current_user doesn't know what 
#	a User is yet, which causes lots of ...
#	NoMethodError (undefined method `find_create_and_update_by_uid' for nil:NilClass):
#	so ...
require 'user'
#	Actually, this is probably only needed in development,
#	but putting it in environments/development.rb doesn't
#	work right, even in an after_initialize.

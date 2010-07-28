# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

#ENV['RAILS_ENV'] ||= 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

#	This constant is used in the ucb_ccls_engine#Document
#	for controlling the path to documents.
RAILS_APP_NAME = 'homex'

Rails::Initializer.run do |config|
	# Settings in config/environments/* take precedence over those specified here.
	# Application configuration should go into files in config/initializers
	# -- all .rb files in that directory are automatically loaded.

	# Add additional load paths for your own custom dirs
	# config.load_paths += %W( #{RAILS_ROOT}/extras )
#	config.load_paths << "#{RAILS_ROOT}/app/sweepers"

	# Specify gems that this application depends on and have them installed with rake gems:install
	# config.gem "bj"
	# config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
	# config.gem "sqlite3-ruby", :lib => "sqlite3"
	# config.gem "aws-s3", :lib => "aws/s3"



	# This is set to /homex in environments/production.rb
	config.action_controller.relative_url_root = ''
	
	if RUBY_PLATFORM =~ /java/
		#	For functionality with rvm/jruby
		#	I expected to have to change database.yml for this but didn't
		config.gem 'activerecord-jdbcmysql-adapter',
			:lib => 'active_record/connection_adapters/jdbcmysql_adapter'

		#	Additional jruby specific jars required in the war
		config.gem 'jdbc-sqlite3', :lib => 'jdbc/sqlite3'
		config.gem 'jruby-openssl', :lib => 'openssl'
		config.gem 'haml'
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

	config.gem "chronic"   #		http://chronic.rubyforge.org/
	config.gem "packet"    #		http://packet.rubyforge.org/
	config.gem 'active_shipping'
	config.gem 'will_paginate'
	config.gem 'fastercsv'


	# Only load the plugins named here, in the order given (default is alphabetical).
	# :all can be used as a placeholder for all plugins not explicitly named
	# config.plugins = [ :exception_notification, :ssl_requirement, :all ]

	# Skip frameworks you're not going to use. To use Rails without a database,
	# you must remove the Active Record framework.
	# config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
	config.frameworks -= [ :active_resource ]

	# Activate observers that should always be running
	# config.active_record.observers = :cacher, :garbage_collector, :forum_observer

	# Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
	# Run "rake -D time" for a list of tasks for finding time zone names.
	config.time_zone = 'UTC'

	# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
	# config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
	# config.i18n.default_locale = :de

#	config.action_view.sanitized_allowed_attributes = 'id', 'class', 'style'
end

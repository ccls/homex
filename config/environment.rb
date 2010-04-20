# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
	# Settings in config/environments/* take precedence over those specified here.
	# Application configuration should go into files in config/initializers
	# -- all .rb files in that directory are automatically loaded.

	# Add additional load paths for your own custom dirs
	# config.load_paths += %W( #{RAILS_ROOT}/extras )
	config.load_paths << "#{RAILS_ROOT}/app/sweepers"

	# Specify gems that this application depends on and have them installed with rake gems:install
	# config.gem "bj"
	# config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
	# config.gem "sqlite3-ruby", :lib => "sqlite3"
	# config.gem "aws-s3", :lib => "aws/s3"



	
	if RUBY_PLATFORM =~ /java/
		#	For functionality with rvm/jruby
		#	I expected to have to change database.yml for this but didn't
		config.gem 'activerecord-jdbcmysql-adapter',
			:lib => 'active_record/connection_adapters/jdbcmysql_adapter'
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

	config.gem "RedCloth"
	config.gem "chronic"			#		http://chronic.rubyforge.org/
	config.gem "packet"			#		http://chronic.rubyforge.org/

	config.gem 'ryanb-acts-as-list', 
		:lib => 'acts_as_list', 
		:source => 'http://gems.github.com'

	#	For user model permissions
	config.gem 'aegis', :source => 'http://gemcutter.org'

	#	For CAS / CalNet Authentication
	config.gem "rubycas-client"

	#	probably will come from http://gemcutter.org/gems/ucb_ldap
	#	version 1.3.2 as of Jan 25, 2010
	config.gem "ucb_ldap", :source => "http://gemcutter.org"

	config.gem 'active_shipping'


#	http://railscasts.com/episodes/160-authlogic
#	http://asciicasts.com/episodes/160-authlogic
#	config.gem 'authlogic'


	# Only load the plugins named here, in the order given (default is alphabetical).
	# :all can be used as a placeholder for all plugins not explicitly named
	# config.plugins = [ :exception_notification, :ssl_requirement, :all ]

	# Skip frameworks you're not going to use. To use Rails without a database,
	# you must remove the Active Record framework.
	# config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

	# Activate observers that should always be running
	# config.active_record.observers = :cacher, :garbage_collector, :forum_observer

	# Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
	# Run "rake -D time" for a list of tasks for finding time zone names.
	config.time_zone = 'UTC'

	# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
	# config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
	# config.i18n.default_locale = :de


#	this will need more appropriate settings

	config.action_mailer.default_url_options = { :host => "dev.sph.berkeley.edu:3000" }
	config.action_mailer.default_content_type = "text/html"

end

Time::DATE_FORMATS[:mdy] = "%b %d, %Y"   # Jan 01, 2009


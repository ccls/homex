# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.

#	normally this is false, but due to the extensions
#	added for the survey, it needs to be true
#	I can't remember exactly what required this to be true.
#	0.10.0 auto includes the extensions so may no longer 
#	require this.  Set to false and we'll see.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true

#	Testing fragment caching and sweeping for page menu
#	so this will need to be true
config.action_controller.perform_caching             = true

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

config.action_mailer.delivery_method = :smtp

config.action_mailer.default_url_options = { 
	:host => "dev.sph.berkeley.edu:3000" }

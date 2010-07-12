require 'ucb_ccls_cms_plugin'


config.load_paths << File.join(File.dirname(__FILE__),'..','/app/sweepers')

config.gem "RedCloth"

#	This works in the app's config/environment.rb ...
#config.action_view.sanitized_allowed_attributes = 'id', 'class', 'style'
#	but apparently not here, so ...
HTML::WhiteListSanitizer.allowed_attributes.merge(%w(
	id class style
))

config.reload_plugins = true if RAILS_ENV == 'development'


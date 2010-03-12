#require 'rails/init' if Rails.env == 'test'
#	Outside of rails, using Rails.env is a little complex
if !defined?(RAILS_ENV) || RAILS_ENV == 'test'
	require 'rails/init' 
end

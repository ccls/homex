require 'rails/active_record'
require 'aegis'
require 'aegis_extension'
 
#ActiveRecord::Base.class_eval do
#	#	override validates_role_name
#  extend AegisExtension::HasRole
#end
Aegis::Role.send(:include, AegisExtension::Role )
Aegis::Permissions.send(:include, AegisExtension::Permissions )
ActionController::Base.send(:include, AegisExtension::ActionController )

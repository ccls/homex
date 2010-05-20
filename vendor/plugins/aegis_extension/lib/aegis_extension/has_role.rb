#module AegisExtension
#	module HasRole
#		def validates_role_name(options = {})
#			validates_each :role_name do |record, attr, value|
##				options[:message] ||= ActiveRecord::Errors.default_error_messages[:inclusion]
##	DEPRECATION WARNING: ActiveRecord::Errors.default_error_messages has been deprecated. Please use I18n.translate('activerecord.errors.messages').. (called from default_error_messages at /Library/Ruby/Gems/1.8/gems/activerecord-2.3.4/lib/active_record/validations.rb:131)
#				options[:message] ||= I18n.translate('activerecord.errors.messages')[:inclusion]
#				role = ::Permissions.find_role_by_name(value)
#				record.errors.add attr, options[:message] if role.nil?
#			end
#		end
#	end
#end

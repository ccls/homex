#if g = Gem.source_index.find_name('ccls-ccls_engine').last
#require 'ccls_engine'
#require g.full_gem_path + '/app/models/user'
#end
#
#User.class_eval do
#
#	== requires
#	*	uid (unique)
#
#	== accessible attributes
#	*	sn
#	*	displayname
#	*	mail
#	*	telephonenumber
#class User < ActiveRecord::Base
class User < Ccls::User

#	ucb_authenticated

#	defined in plugin/engine ...
#
#	def may_administrate?(*args)
#		(self.role_names & ['superuser','administrator']).length > 0
#	end
#
#	def may_read?(*args)
#		(self.role_names & 
#			['superuser','administrator','editor','interviewer','reader']
#		).length > 0
#	end
#
#	def may_edit?(*args)
#		(self.role_names & 
#			['superuser','administrator','editor']
#		).length > 0
#	end

#	alias_method :may_create?,  :may_edit?
#	alias_method :may_update?,  :may_edit?
#	alias_method :may_destroy?, :may_edit?
#
#	alias_method :may_take_surveys?, :may_administrate?

#	%w(	people races sample_kits
#			languages gift_cards refusal_reasons ineligible_reasons
#			document_versions
	%w(	sample_kits gift_cards document_versions).each do |resource|
		alias_method "may_create_#{resource}?".to_sym,  :may_administrate?
		alias_method "may_read_#{resource}?".to_sym,    :may_administrate?
		alias_method "may_edit_#{resource}?".to_sym,    :may_administrate?
		alias_method "may_update_#{resource}?".to_sym,  :may_administrate?
		alias_method "may_destroy_#{resource}?".to_sym, :may_administrate?
	end

	%w(	contacts guides home_page_pics patients
			response_sets interviews samples
			).each do |resource|
		alias_method "may_create_#{resource}?".to_sym,  :may_edit?
		alias_method "may_read_#{resource}?".to_sym,    :may_edit?
		alias_method "may_edit_#{resource}?".to_sym,    :may_edit?
		alias_method "may_update_#{resource}?".to_sym,  :may_edit?
		alias_method "may_destroy_#{resource}?".to_sym, :may_edit?
	end

	%w(	addressings addresses home_exposures phone_numbers
			).each do |resource|
		alias_method "may_create_#{resource}?".to_sym,  :may_create?
		alias_method "may_read_#{resource}?".to_sym,    :may_read?
		alias_method "may_edit_#{resource}?".to_sym,    :may_edit?
		alias_method "may_update_#{resource}?".to_sym,  :may_update?
		alias_method "may_destroy_#{resource}?".to_sym, :may_destroy?
	end

	%w(	enrollments home_exposure_responses packages projects subjects
			events
			).each do |resource|
		alias_method "may_create_#{resource}?".to_sym,  :may_read?
		alias_method "may_read_#{resource}?".to_sym,    :may_read?
		alias_method "may_edit_#{resource}?".to_sym,    :may_read?
		alias_method "may_update_#{resource}?".to_sym,  :may_read?
		alias_method "may_destroy_#{resource}?".to_sym, :may_read?
	end

end

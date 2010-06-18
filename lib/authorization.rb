module Authorization

	module Controller
		def self.included(base)
			base.send(:include, InstanceMethods)
			base.alias_method_chain :method_missing, :authorization
		end

		module InstanceMethods

			def method_missing_with_authorization(symb,*args, &block)
				method_name = symb.to_s







				method_missing_without_authorization(symb, *args, &block)
			end

		end
	end

	module User
		def self.included(base)
			base.send(:include, InstanceMethods)
		end

		module InstanceMethods

#	permission :administrate do
#	permission :moderate do
#	permission :deputize do
#	permission :view_permissions do
#	permission :create_user_invitations do
#	permission :view_users do
#	permission :maintain_pages do
#	permission :view_home_page_pics do
#	permission :view_calendar do
#	permission :view_packages do
#	permission :crud_addresses do |current_user,address|
#	permission :view_user do |current_user,user|
#	permission :be_user do |current_user,target_user|
#	permission :assign_roles do
#	permission :view_responses do
#	permission :take_surveys do
#	permission :view_study_events do
#	permission :view_subjects do
#	permission :view_dust_kits do
#	permission :create_survey_invitations do

		end
	end

end
ActionController::Base.send(:include,Authorization::Controller)
User.send(:include,Authorization::User)

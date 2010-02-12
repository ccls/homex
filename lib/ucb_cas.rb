require 'casclient'
require 'casclient/frameworks/rails/filter'

#	https://calnet.berkeley.edu/developers/developerResources/cas/CASAppSetup.html#firstLevelServers

#	I know.  Naming isn't conventional.  Sue me.
#	UCB::CAS looks more appropriate, since they are acronyms, than Ucbcas
module UCB::CAS

	def self.included(base)
		base_server_url = ( RAILS_ENV == "production" ) ?  "https://auth.berkeley.edu" : "https://auth-test.berkeley.edu"

		CASClient::Frameworks::Rails::Filter.configure(
			:username_session_key => :calnetuid,
			:cas_base_url => "#{base_server_url}/cas/"
		)

		base.send(:before_filter,:cas_filter)
	end

protected

	def cas_filter
		# Have to add ".filter(self)" when not in before_filter line.
		CASClient::Frameworks::Rails::Filter.filter(self)
	end

	# This will allow the user to view the page without authentication
	# but will process CAS authentication data if the user already
	# has an SSO session open.
	def cas_gateway_filter
		# Have to add ".filter(self)" when not in before_filter line.
		CASClient::Frameworks::Rails::GatewayFilter.filter(self)
		@login_url = CASClient::Frameworks::Rails::Filter.login_url(self)
	end

end

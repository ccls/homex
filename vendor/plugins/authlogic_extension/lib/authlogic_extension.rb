# AuthlogicExtension
if defined?(Authlogic)
#require 'authlogic'
require 'authlogic_extension/perishable_token'
require 'authlogic_extension/persistence_token'
Authlogic::ActsAsAuthentic::PerishableToken::Methods::InstanceMethods.send(
	:include, AuthlogicExtension::ActsAsAuthentic::PerishableToken)
Authlogic::ActsAsAuthentic::PersistenceToken::Methods::InstanceMethods.send(
	:include, AuthlogicExtension::ActsAsAuthentic::PersistenceToken)
end

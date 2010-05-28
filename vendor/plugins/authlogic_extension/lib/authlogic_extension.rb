# AuthlogicExtension
if defined?(Authlogic)
::ActiveRecord::Base.send :include, AuthlogicExtension::ActsAsAuthentic::PerishableToken
::ActiveRecord::Base.send :include, AuthlogicExtension::ActsAsAuthentic::PersistenceToken
end

require 'active_record'
require 'acts_as_translatable'

ActiveRecord::Base.send( :include, Acts::Translatable )

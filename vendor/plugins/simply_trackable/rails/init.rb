require 'active_record'
require 'acts_as_trackable'
require 'track'

ActiveRecord::Base.send( :include, Acts::Trackable )

# ActsAsTrackable
module Acts #:nodoc:
	module Trackable #:nodoc:
		def self.included(base)
			base.extend(ClassMethods)
		end

		module ClassMethods
			def acts_as_trackable(options = {})
				has_many	:tracks, :as => :trackable, :dependent => :destroy
				validates_length_of :tracking_number, :minimum => 3
				validates_uniqueness_of :tracking_number

				if self.accessible_attributes
					attr_accessible :tracking_number
				end

			end
		end
	end
end

#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
class OperationalEventType < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :operational_events

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

	class NotFound < StandardError; end

	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

end

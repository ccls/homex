#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
class OperationalEventType < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :operational_events

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_presence_of   :description
	validates_uniqueness_of :description
	validates_presence_of   :event_category
	validates_uniqueness_of :event_category

	with_options :allow_blank => true do |o|
		o.validates_length_of :code, :maximum => 250
		o.validates_length_of :description, :in => 4..250
		o.validates_length_of :event_category, :in => 4..250
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

	#	Returns event_category
	def to_s
#		description
		event_category
	end

end

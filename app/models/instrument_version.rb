#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
#	*	interview_type_id
class InstrumentVersion < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	belongs_to :language
	belongs_to :interview_type
	belongs_to :instrument
	has_many :interviews

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

	validates_presence_of :interview_type_id, :interview_type

	validates_complete_date_for :began_use_on, :ended_use_on,
		:allow_nil => true

	def to_s
		description
	end

#	class NotFound < StandardError; end

	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

end

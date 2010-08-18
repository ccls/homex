# don't know exactly
class InterviewOutcome < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :homex_outcomes

	validates_presence_of   :code
	validates_uniqueness_of :code
#	validates_length_of     :description, :minimum => 4
#	validates_uniqueness_of :description
#
#	def to_s
#		description
#	end
#
#	def name
#		description
#	end

end

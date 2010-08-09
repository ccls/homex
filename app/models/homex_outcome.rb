class HomexOutcome < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	belongs_to :subject
	belongs_to :sample_outcome
	belongs_to :interview_outcome

	validates_uniqueness_of :subject_id
	validates_presence_of :subject_id, :subject

#	validates_presence_of   :code
#	validates_uniqueness_of :code
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

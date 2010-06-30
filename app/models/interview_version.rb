#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
#	*	interview_type_id
class InterviewVersion < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	belongs_to :language
	belongs_to :interview_type
	has_many :interviews

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

	validates_presence_of :interview_type_id, :interview_type

end

#	==	requires
#	*	description ( unique and > 3 chars )
#	*	project
class InterviewType < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	belongs_to :project
	has_many :instrument_versions

	validates_presence_of :project_id, :project
	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description
	validates_length_of :code, :description,
		:maximum => 250, :allow_blank => true

end

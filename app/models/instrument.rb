class Instrument < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	belongs_to :project
	belongs_to :interview_method

	validates_presence_of   :project_id
	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_presence_of   :name
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

	def to_s
		name
	end

end

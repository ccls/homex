class ProjectOutcome < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_presence_of   :description
	validates_uniqueness_of :description

	def to_s
		description
	end

end

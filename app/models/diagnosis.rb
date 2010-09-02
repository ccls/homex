#	don't know
class Diagnosis < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

#	has_many :subjects

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 3
	validates_uniqueness_of :description

	def to_s
		description
	end

end

#	==	requires
#	*	description (unique and >3 chars)
class Context < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :units
#	has_many :people

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description
	validates_length_of :code, :description,
		:maximum => 250, :allow_blank => true
end

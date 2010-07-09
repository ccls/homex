#	==	requires
#	*	description ( unique and > 3 chars )
class RefusalReason < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	has_many :enrollments

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

	def to_s
		code
	end

end

#	==	requires
#	*	description ( unique and > 3 chars )
#	*	sample_type_id
class SampleSubtype < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	belongs_to :sample_type
	has_many :samples
#	sample subtype and type could be self referential

	validates_presence_of :sample_type_id, :sample_type
	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

end

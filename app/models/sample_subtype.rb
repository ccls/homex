class SampleSubtype < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	belongs_to :sample_type
	has_many :samples
#	sample subtype and type could be self referential
	validates_length_of :description, :minimum => 4
	validates_presence_of :sample_type_id
	validates_uniqueness_of :description
end

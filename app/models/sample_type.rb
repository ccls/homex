#	==	requires
#	*	description ( unique and > 3 chars )
class SampleType < ActiveRecord::Base
	acts_as_list :scope => :parent_id
	default_scope :order => :position

	has_many :samples
	belongs_to :parent, :class_name => 'SampleType'
	has_many :children, :class_name => 'SampleType', 
		:foreign_key => 'parent_id',
		:dependent => :nullify
	
	named_scope :roots, :conditions => { 
		:parent_id => nil }

	named_scope :not_roots, :conditions => [
		'sample_types.parent_id IS NOT NULL' ]

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

	#	Returns description
	def to_s
		description
	end

end

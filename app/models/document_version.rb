class DocumentVersion < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position
	belongs_to :document_type
	has_many :enrollments

	validates_presence_of :document_type_id,
		:document_type

	#	Return title
	def to_s
		title
	end

	named_scope :type1, :conditions => {
		:document_type_id => 1 }

end

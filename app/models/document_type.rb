class DocumentType < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position
	has_many :document_versions
	validates_length_of :title, :description,
		:maximum => 250, :allow_blank => true
end

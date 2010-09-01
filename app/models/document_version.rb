class DocumentVersion < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position
	belongs_to :document_type
end

class Sample < ActiveRecord::Base
	belongs_to :aliquot_sample_format
	belongs_to :sample_subtype
	belongs_to :subject
	belongs_to :unit
#	belongs_to :organization
	has_many :aliquots

	validates_presence_of :subject_id
	validates_presence_of :unit_id
end

class Aliquot < ActiveRecord::Base
	belongs_to :sample
	belongs_to :unit
	belongs_to :aliquot_sample_format
	has_many :transfers
end

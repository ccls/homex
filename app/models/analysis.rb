class Analysis < ActiveRecord::Base
	has_and_belongs_to_many :subjects

	belongs_to :analyst, :class_name => 'Person'
	belongs_to :analytic_file_creator, :class_name => 'Person'
	belongs_to :project

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description
end
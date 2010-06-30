class Analysis < ActiveRecord::Base
	has_and_belongs_to_many :subjects
	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description
end

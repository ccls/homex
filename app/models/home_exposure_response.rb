# Extraction of answers from the survey
class HomeExposureResponse < ActiveRecord::Base
	belongs_to :subject

	validates_presence_of   :subject_id, :subject
	validates_uniqueness_of :subject_id

	def self.q_column_names
		column_names - 
			%w( id subject_id childid created_at updated_at ) -
			%w( vacuum_bag_last_changed vacuum_used_outside_home )
	end

end

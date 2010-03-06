class Pii < ActiveRecord::Base
	belongs_to :subject

	validates_presence_of :subject_id
	validates_presence_of   :ssn
	validates_uniqueness_of :ssn
	validates_format_of     :ssn, :with => /\A\d{3}-?\d{2}-?\d{4}\Z/
	validates_presence_of   :state_id_no
	validates_uniqueness_of :state_id_no
end

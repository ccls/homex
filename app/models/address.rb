class Address < ActiveRecord::Base
	default_scope :order => 'created_at DESC'

	has_many :interviews
	has_one :residence
	belongs_to :subject
	belongs_to :address_type
	belongs_to :data_source

	validates_presence_of :subject_id, :subject

	def csz
		"#{self.city}, #{self.state} #{self.zip}"
	end

end

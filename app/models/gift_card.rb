class GiftCard < ActiveRecord::Base
	belongs_to :subject
	belongs_to :project
	validates_presence_of   :number
	validates_uniqueness_of :number
	validates_length_of :expiration, :vendor, :number,
		:maximum => 250, :allow_blank => true

	def to_s
		number
	end

end

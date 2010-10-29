class GiftCard < ActiveRecord::Base
	belongs_to :subject
	belongs_to :project
	validates_presence_of   :number
	validates_uniqueness_of :number

	def to_s
		number
	end

end

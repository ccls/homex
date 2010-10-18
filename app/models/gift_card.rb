class GiftCard < ActiveRecord::Base
	belongs_to :subject
	belongs_to :project
	validates_presence_of   :gift_card_number
	validates_uniqueness_of :gift_card_number

	def to_s
		gift_card_number
	end

#	def number
#		gift_card_number
#	end
#
#	def type
#		gift_card_type
#	end

end

class GiftCard < ActiveRecord::Base
	belongs_to :subject
	belongs_to :project
	validates_presence_of   :gift_card_number
	validates_uniqueness_of :gift_card_number
end

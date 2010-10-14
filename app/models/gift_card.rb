class GiftCard < ActiveRecord::Base
	belongs_to :subject
	belongs_to :project
	validated_presence_of   :gift_card_number
	validated_uniqueness_of :gift_card_number
end

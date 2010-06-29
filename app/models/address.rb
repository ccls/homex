class Address < ActiveRecord::Base
	has_many :interviews
	has_one :residence
	belongs_to :subject
	belongs_to :address_type
	belongs_to :data_source
end

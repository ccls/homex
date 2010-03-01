class Residence < ActiveRecord::Base
	belongs_to :address
	belongs_to :subject
end

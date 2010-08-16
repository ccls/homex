class PhoneNumber < ActiveRecord::Base
#	acts_as_list :scope => :subject_id
	belongs_to :subject
end

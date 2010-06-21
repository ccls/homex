class Post < ActiveRecord::Base
	has_many :comments,
		:as => :commentable
	belongs_to :user, 
		:counter_cache => true
end

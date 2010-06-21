class User < ActiveRecord::Base
	has_many :blogs
	has_many :posts
	has_many :comments, :as => :commenter

	def self.something_classy

	end

	def something_instancey

	end
end

class Comment < ActiveRecord::Base
	#	This will parse incorrectly, ignoring the definition
	#	of :class_name => "User"
	belongs_to :commenter, 
		:class_name => "User",
		:counter_cache => true

	#	This has no idea who or what commentable is.
	belongs_to :commentable, 
		:polymorphic => true,
		:counter_cache => true
end

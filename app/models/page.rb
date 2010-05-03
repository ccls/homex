#	==	requires
#	*	path ( unique, > 1 char and starts with a / )
#	*	menu ( unique and > 3 chars )
#	*	title ( > 3 chars )
#	*	body ( > 3 chars )
#
#	==	named_scope(s)
#	*	not_home (returns those pages where path is not just '/')
#	*	roots
#
#	uses acts_as_list for parent / child relationship.  As this
#	is only a parent and child and no deeper, its ok.  If it
#	were to get any deeper, the list should probably be changed
#	to something like a nested set.
class Page < ActiveRecord::Base
	acts_as_list :scope => :parent_id
	default_scope :order => :position

	validates_length_of :path,  :minimum => 1
	validates_format_of :path,  :with => /^\//
	validates_length_of :menu,  :minimum => 4
	validates_length_of :title, :minimum => 4
	validates_length_of :body,  :minimum => 4
	validates_uniqueness_of :menu
	validates_uniqueness_of :path
	validates_length_of     :controller, :minimum => 4, 
		:allow_nil => true, :allow_blank => true
	validates_uniqueness_of :controller, 
		:allow_nil => true, :allow_blank => true

	belongs_to :parent, :class_name => 'Page'
	has_many :children, :class_name => 'Page', :foreign_key => 'parent_id'
	
	named_scope :roots, :conditions => [ "parent_id IS NULL" ]
	named_scope :not_home, :conditions => [ "path != '/'" ]

	attr_accessible :path, :menu, :title, :body, :parent_id, :controller

	before_validation :adjust_path
	def adjust_path
		#	remove any duplicate /'s
		#	add leading / if none
		self.path = path.try(:downcase)
	end

#	#	why is this after?
#	#	All errors and testing work with a before_validation
#	after_validation :downcase_path
#	#	downcase the path attribute
#	def downcase_path
##		self.path = path.try(:downcase)
#	end

	#	named_scopes ALWAYS return an "Array"
	#	so if ONLY want one, MUST use a method.
	#	by_path returns the one(max) page that
	#	matches the given path.
	def self.by_path(path)
		find(:first,
			:conditions => {
				:path => path.downcase
			}
		)
	end

	def root
		page = self
		until page.parent == nil
			page = page.parent
		end 
		page
	end

	def is_home?
		self.path == "/"
	end

end

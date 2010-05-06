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
	default_scope :order => :position

#	acts_as_list 
#	#	due to the apparently complex scope, the acts_as_list 
#	#	scope condition method is done here by hand.
#	def scope_condition
#		scope = if parent_id.nil?
#			"parent_id IS NULL"
#		else
#			"parent_id = '#{parent_id}'"
#		end
#		scope << " AND locale = '#{locale}'"
#	end

	acts_as_list :scope => "parent_id \#{(parent_id.nil?)?'IS NULL':'= parent_id'} AND locale = '\#{locale}'"


	validates_length_of :path,  :minimum => 1
	validates_format_of :path,  :with => /^\//
	validates_length_of :menu,  :minimum => 4
	validates_length_of :title, :minimum => 4
	validates_length_of :body,  :minimum => 4
	validates_uniqueness_of :menu, :scope => :locale
	validates_uniqueness_of :path, :scope => :locale
	validates_length_of     :controller, :minimum => 4, 
		:allow_nil => true, :allow_blank => true
	validates_uniqueness_of :controller, 
		:allow_nil => true, :allow_blank => true

	belongs_to :parent, :class_name => 'Page'
	has_many :children, :class_name => 'Page', :foreign_key => 'parent_id'
	
#
#	Add locale argument to roots
#
	named_scope :roots, :conditions => { 
		:parent_id => nil, :hide_menu => false }
	named_scope :not_home, :conditions => [ "path != '/'" ]

	attr_accessible :path, :menu, :title, :body, 
		:parent_id, :hide_menu
#		:parent_id, :controller, :hide_menu

	#	This MUST be AFTER attr_accessible, otherwise
	#	the attributes added in the plugin won't be
	#	mass-assignable.
	acts_as_translatable :locales => [ 'en', 'es' ], 
		:sync => [:position,:hide_menu]


	before_validation :adjust_path
	before_save :set_parent_id_to_locale_parent
	after_save  :set_translation_children_to_locale_parent


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
	def self.by_path(path, locale = 'en')
		find(:first,
			:conditions => {
				:path => path.downcase,
				:locale => locale
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

protected

	#	If I am the translation of a child, then
	#	try to find my correct locale parent.
	def set_parent_id_to_locale_parent
		if !self.parent_id.nil? &&
			self.parent.locale != self.locale
#			pa = self.parent.translatable.translations.first(
			pa = self.parent.translations.first(
				:conditions => { :locale => self.locale })
			self.parent = pa unless pa.nil?
		end
	end

	#	If I am the translation of a parent, then
	#	try to find any children of my translations
	#	and adopt those with my locale.
	def set_translation_children_to_locale_parent
#		self.translations.each do |t|
#	^ doesn't work for translations ??
		self.translatable.translations.each do |t|
			t.children.each do |c|
				if c.locale == self.locale
					c.update_attribute(:parent_id, self.id)
				end
			end
		end
	end

end

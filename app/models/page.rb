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
	
	named_scope :roots, lambda { |*args| { :conditions => { 
		:parent_id => nil, :hide_menu => false, 
		:locale => args.first || self.default_locale } } }

	named_scope :not_home, :conditions => [ "path != '/'" ]

	attr_accessible :path, :menu, :title, :body, 
		:parent_id, :hide_menu, :position
	#	adding :position to this set minimizes the effect
	#	of creating a page's translation

	#	This MUST be AFTER attr_accessible, otherwise the 
	#	attributes added in the plugin won't be mass-assignable.
	acts_as_translatable :locales => [ 'en', 'es' ], 
		:sync => [:position,:hide_menu]
#		:sync => [:hide_menu]

	before_validation :adjust_path
	before_save :find_locale_parent
	after_save  :set_translation_children_to_locale_parent
	after_save  :set_translations_parent_id_to_locale_parent

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
	def self.by_path(path, locale = self.default_locale)
		locale ||= self.default_locale
#
#	Loop through possible searches with locale
#	in path, not in path, translations, etc.
#
		page = find(:first,
			:conditions => {
				:path   => path.downcase,
				:locale => locale
			}
		) || find(:first,
			:conditions => {
				:path   => path.downcase,
				:locale => self.default_locale
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
	def find_locale_parent
		if !self.parent_id.nil? &&
			self.parent.locale != self.locale
			pa = self.class.find(:first,:conditions => {
				:translatable_id => self.parent_id,
				:locale => self.locale })
#			pa = self.parent.translatable.translations.first(
#			pa = self.parent.translations.first(
#				:conditions => { :locale => self.locale })
			# THIS IS IN A BEFORE_SAVE CALL
			self.parent = pa unless pa.nil?
		end
	end

	#	If I am the translation of a parent, then
	#	try to find any children of my translations
	#	and adopt those with my locale.
	#	Use update_all to avoid AR callbacks and looping forever.
	def set_translation_children_to_locale_parent
		self.class.find(:all, :conditions => {
			:translatable_id => self.translatable_id
		}).each do |t|
			t.children.each do |c|
				self.class.update_all({ :parent_id, self.id },
					{:id => c.id }) if( c.locale == self.locale )
			end
		end
	end

	#	Loop through all translations and set to locale
	#	parent if it exists.  
	#	Use update_all to avoid AR callbacks and looping forever.
	def set_translations_parent_id_to_locale_parent
		if self.parent_id.nil?
			self.class.update_all({ :parent_id => nil },
				{:translatable_id => self.translatable_id })
		else
			( self.class.find(:all,:conditions => {
				:translatable_id => self.translatable_id
			}) - [self] ).each do |t|
				pa = self.class.find(:first, :conditions => { 
					:translatable_id => self.parent.translatable_id,
					:locale => t.locale })
				if !pa.nil? && t.parent_id != pa.id
					self.class.update_all({ :parent_id => pa.id },
						{:id => t.id })
				end
			end
		end
	end

end

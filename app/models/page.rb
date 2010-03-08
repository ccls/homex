class Page < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position

	validates_length_of :path,  :minimum => 1
	validates_format_of :path,  :with => /^\//
	validates_length_of :menu,  :minimum => 4
	validates_length_of :title, :minimum => 4
	validates_length_of :body,  :minimum => 4
	validates_uniqueness_of :menu
	validates_uniqueness_of :path
	
	named_scope :not_home, :conditions => [ "path != '/'" ]

	attr_accessible :path, :menu, :title, :body

	after_validation :downcase_path
	def downcase_path
		self.path = path.try(:downcase)
	end

	#	named_scopes ALWAYS return an "Array"
	#	so if ONLY want one, MUST use a method.
	def self.by_path(path)
		find(:first,
			:conditions => {
				:path => path.downcase
			}
		)
	end

end

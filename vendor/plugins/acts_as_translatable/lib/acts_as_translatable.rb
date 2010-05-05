# ActsAsTranslatable
module Acts #:nodoc:
	module Translatable #:nodoc:
		def self.included(base)
			base.extend(InitialClassMethods)
		end

		module InitialClassMethods
			def acts_as_translatable(options = {})
				#	There has to be a cleaner, more correct way
				#	to do this, but it works.
				class_eval <<-EOV
				cattr_reader :translatable_options
				@@translatable_options = { :default_locale => :en }
				@@translatable_options.update(options) if options.is_a?(Hash)
				EOV

				include Acts::Translatable::InstanceMethods
				extend  Acts::Translatable::ClassMethods

				belongs_to :translatable, 
					:class_name => self.class_name

				has_many :translations, 
					:class_name  => self.class_name,
					:foreign_key => 'translatable_id',
					:dependent => :delete_all

				#	as a translatable is a translation of itself,
				#		:dependent => :destroy 
				#	creates an infinite loop
				#	If associations need a destroy, an after or before
				#	destroy macro method should be created.

				if self.accessible_attributes
					attr_accessible :locale
					attr_accessible :translatable_id
					attr_accessible :translations_attributes
				end

#				validates_presence_of :locale, :if => :translatable
#				validates_presence_of :locale, :if => :translatable_id

				validates_uniqueness_of :locale, 
					:scope => :translatable_id

				before_create :set_locale
				after_create  :set_translatable
			end
		end

		module ClassMethods

			def default_locale
				translatable_options[:default_locale].to_s || "en"
			end

		end 

		module InstanceMethods

			def translate(locale)
				self.translations.find(:first, 
					:conditions => {:locale => locale}) || self
			end

		protected

			def set_locale
				self.locale ||= self.class.default_locale
				#	no save needed as this is a before_create
			end

			def set_translatable
				self.translatable_id ||= self.id
				#	as this is an after_create, save is needed
				save(false)
			end

		end 
	end
end

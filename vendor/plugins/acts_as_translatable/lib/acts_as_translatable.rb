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
				@@translatable_options.update(options)
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

				#	Because of this if condition, the statement ...
				#		acts_as_translatable ...
				#	... in your model MUST come after the first 
				#		attr_accessible ...
				#	if there is one.
				if self.accessible_attributes
					attr_accessible :locale
					attr_accessible :translatable_id
				end

#				validates_presence_of :locale, :if => :translatable
#				validates_presence_of :locale, :if => :translatable_id
				validates_length_of :locale, :minimum => 2

				validates_uniqueness_of :locale, 
					:scope => :translatable_id

				before_validation :set_locale
				after_create      :set_translatable
				after_save        :sync_translations
#	doesn't seem to matter which
#				before_save       :sync_translations
			end
		end

		module ClassMethods

			def default_locale
				translatable_options[:default_locale].to_s || "en"
			end

			def locales
				translatable_options[:locales] || [:en]
			end

			def sync_attrs
				translatable_options[:sync] || []
			end

		end 

		module InstanceMethods

			def translate(locale,attrs={})
#
#	clean this up
#	something like ...
#	find_or_create_by_locale(self.attributes.merge(attrs))
#	should work and replace all this 
#
#	make sure that it works for translations too
#
#				self.class.find_or_create_by_locale_and_translatable_id(
				conditions = HashWithIndifferentAccess.new(self.attributes).merge(
					attrs.merge({
						:locale => locale,
						:translatable_id => self.translatable_id
					})
				)
#	use string keys as that is what is in self.attributes
#	may need to do something to attrs as that comes from the user not me
#	because the first in the chain is a HWIA, everything else
#	will be
#puts self.attributes.inspect
#puts attrs.inspect
#puts conditions.inspect
				self.class.find_or_create_by_locale_and_translatable_id(
					conditions
				)
#	self.translations doesn't always include everyone 
#				self.translations.find(:first, 
#					:conditions => {:locale => locale}) || self.class.create(
#					self.attributes.merge(:locale => locale).merge(attrs))
			end

		protected

			def set_locale
				self.locale ||= self.class.default_locale
				#	no save needed as this is a before_validation
			end

			def set_translatable
				self.translatable_id ||= self.id
				#	as this is an after_create, save is needed
				save(false)
			end

			def sync_attributes
				attrs = {}
				self.class.sync_attrs.each do |attr|
					attrs[attr] = self.send(attr)
				end
				attrs
			end

			def sync_translations
#	for some reason this isn't returning all translations?????
#				( self.translatable.translations - [self] ).each do |t|
#	but this does ...
#				( self.class.find(:all, :conditions => {
#					:translatable_id => self.translatable_id}) - [self] ).each do |t|
#					self.class.sync_attrs.each do |attr|
#						t.send("#{attr}=",self.send(attr))
#					end
#					#	avoid an infinite loop with the dirty check
#					t.save(false) if t.changed?
#				end

				#	less logic, more power
				self.class.update_all( sync_attributes,
					{:translatable_id => self.translatable_id})
			end

		end 
	end
end

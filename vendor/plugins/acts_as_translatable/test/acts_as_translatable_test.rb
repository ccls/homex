require File.dirname(__FILE__) + '/test_helper'

class ActsAsTranslatableTest < ActiveSupport::TestCase

	def setup
		setup_db
	end

	def teardown
		teardown_db
	end

	test "should create page" do
		assert_difference('Page.count',1) do
			page = create_page
		end
	end

	test "should create page and not require locale" do
		assert_difference('Page.count',1) do
			create_page(:locale => nil)
		end
	end

	test "should create page and not require translatable" do
		assert_difference('Page.count',1) do
			create_page(:translatable_id => nil)
		end
	end

	test "should create page and set translatable to id if nil" do
		assert_difference('Page.count',1) do
			page = create_page(:translatable_id => nil)
			assert_equal page.id, page.translatable_id
		end
	end

	test "should create page and set locale to default if nil" do
		assert_difference('Page.count',1) do
			page = create_page(:locale => nil)
			assert_equal page.locale, Page.default_locale
		end
	end

	test "should require locale for translation" do
		translatable = create_page
		assert_difference('Page.count',0) do
			page = create_page(:translatable_id => translatable.id)
			assert page.errors.on(:locale)
		end
	end

	test "should require unique locale for translation" do
		translatable = create_page
		translatable.translate('es')
		assert_difference('Page.count',0) do
			page = create_page(:translatable_id => translatable.id, 
				:locale => 'es')
			assert page.errors.on(:locale)
		end
	end

	test "should require 2 char minimum locale" do
		translatable = create_page
		assert_difference('Page.count',0) do
			page = translatable.translate('')
			assert page.errors.on(:locale)
		end
	end

	test "should only create one translation per locale" do
		assert_difference('Page.count',2) do
			translatable = create_page
			translatable.translate('es')
			translatable.translate('es')
			translatable.translate('es')
		end
	end

	test "should include self in translations" do
		page = create_page
		assert_equal 1, page.translations.count
	end

	test "should include self in translations with translations as translatable" do
		page = create_page
		page.translate('es')
		assert_equal 2, page.translations.count
	end

	test "should include self in translatable translations as translation" do
		page = create_page
		translation = page.translate('es')
		assert_equal 2, translation.translatable.translations.count
	end

	test "should have many translations" do
		page = create_page
		assert_equal 1, page.translations.count
		assert_difference("Page.find(#{page.id}).translations.count",3) {
		assert_difference('Page.count',3) {
			p = page.translate('es')
			assert_equal p.translatable, page
			p = page.translate('fr')
			assert_equal p.translatable, page
			p = page.translate('de')
			assert_equal p.translatable, page
		} }
	end

	test "should destroy all translations on destroy" do
		translatable = create_page
		create_page(:translatable_id => translatable.id, 
			:locale => 'es')
		assert_equal 2, translatable.translations.count
		assert_difference('Page.count',-2) {
			translatable.destroy
		}
	end

	test "should get translation of translatable" do
		page = create_page(:title => 'original')
		page.translate('es')
		page.translate('fr')
		translation = page.translate('es')
		assert_equal translation.locale, 'es'
	end

	test "should return self if translation locale doesn't exist" do
		page = create_page(:title => 'original')
		page.translate('es')
		page.translate('fr')
		assert_equal 3, page.translations.count
		translation = page.translate('ru')
		assert_equal 4, page.translations.count
		assert_equal translation.locale, 'ru'
	end

	test "should return available locales" do
		locales = Page.locales.collect(&:to_s)
		assert_equal 3, locales.length
		assert locales.include?('en')
		assert locales.include?('es')
	end

	test "should sync translations after translation save" do
		assert_difference('Page.count',2) do
			page_en = create_page(:title => 'original', :position => 9)
			page_es = page_en.translate('es')
			assert_equal page_en.position, page_es.position
			page_es.update_attribute(:position, 42)
			assert_equal page_en.reload.position, 42
			assert_equal page_en.reload.position, page_es.reload.position
		end
	end

	test "should sync translations after original save" do
		assert_difference('Page.count',2) do
			page_en = create_page(:title => 'original', :position => 9)
			page_es = page_en.translate('es')
			assert_equal page_en.position, page_es.position
			page_en.update_attribute(:position, 42)
			assert_equal page_en.reload.position, 42
			assert_equal page_en.reload.position, page_es.reload.position
		end
	end

	test "should allow translating translations" do
		assert_difference('Page.count',3) do
			original = create_page
			translation = original.translate('es')
			second = translation.translate('fr')
			assert_equal second.translatable_id, original.id
		end
	end

protected

	def create_page(options={})
		page = Page.new(options)
		page.save
		page
	end

end

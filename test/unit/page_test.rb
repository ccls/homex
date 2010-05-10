require File.dirname(__FILE__) + '/../test_helper'

class PageTest < ActiveSupport::TestCase

	test "should create page" do
		assert_difference 'Page.count' do
			page = create_page
			assert !page.new_record?, 
				"#{page.errors.full_messages.to_sentence}"
		end
	end

	test "should require path" do
		assert_no_difference 'Page.count' do
			page = create_page(:path => nil)
			assert page.errors.on(:path)
		end
	end

	test "should require path begin with slash" do
		assert_no_difference 'Page.count' do
			page = create_page(:path => 'Hey')
			assert page.errors.on(:path)
		end
	end

	test "should require 1 char path" do
		assert_no_difference 'Page.count' do
			page = create_page(:path => '')
			assert page.errors.on(:path)
		end
	end

	test "should require unique path" do
		p = create_page
		assert_no_difference 'Page.count' do
			page = create_page(:path => p.path)
			assert page.errors.on(:path)
		end
	end

	test "should require menu" do
		assert_no_difference 'Page.count' do
			page = create_page(:menu => nil)
			assert page.errors.on(:menu)
		end
	end

	test "should require unique controller" do
		p = create_page(:controller => 'foobar')
		assert_no_difference 'Page.count' do
			page = create_page(:controller => p.controller)
			assert page.errors.on(:controller)
		end
	end

	test "should require 4 char controller" do
		assert_no_difference 'Page.count' do
			page = create_page(:controller => 'Hey')
			assert page.errors.on(:controller)
		end
	end

	test "should require unique menu" do
		p = create_page
		assert_no_difference 'Page.count' do
			page = create_page(:menu => p.menu)
			assert page.errors.on(:menu)
		end
	end

	test "should require 4 char menu" do
		assert_no_difference 'Page.count' do
			page = create_page(:menu => 'Hey')
			assert page.errors.on(:menu)
		end
	end

	test "should require title" do
		assert_no_difference 'Page.count' do
			page = create_page(:title => nil)
			assert page.errors.on(:title)
		end
	end

	test "should require 4 char title" do
		assert_no_difference 'Page.count' do
			page = create_page(:title => 'Hey')
			assert page.errors.on(:title)
		end
	end

	test "should require body" do
		assert_no_difference 'Page.count' do
			page = create_page(:body => nil)
			assert page.errors.on(:body)
		end
	end

	test "should require 4 char body" do
		assert_no_difference 'Page.count' do
			page = create_page(:body => 'Hey')
			assert page.errors.on(:body)
		end
	end

	test "can have a parent" do
		parent = create_page
		page = create_page( :parent_id => parent.id )
		assert_equal page.reload.parent, parent
	end

	test "should return self as root with no parent" do
		page = create_page
		assert_equal page, page.root
	end

	test "should return parent as root with parent" do
		parent = create_page
		page = create_page( :parent_id => parent.id )
		assert_equal parent, page.reload.root
	end

	test "should return false if page is not home" do
		page = create_page
		assert !page.is_home?
	end

	test "should return true if page is home" do
		page = create_page(:path => '/')
		assert page.is_home?
	end

	test "should create page with hide_menu true" do
		page = create_page(:hide_menu => true)
		assert_equal 1, Page.count
		assert_equal 0, Page.roots.count
		assert_not_nil Page.find(page)
		assert_not_nil Page.find(page.id)
		assert_not_nil Page.find_by_path(page.path)
	end

	test "should create translation of page" do
		page = create_page
		translation = page.translate('es')
		%w( translatable_id position parent_id title body hide_menu 
			).each do |attr|
			assert_equal page.send(attr), translation.send(attr)
		end
	end

	test "should create translation of child page" do
		parent_en = create_page
		child_en = create_page(:parent_id => parent_en.id)
		child_es = child_en.translate('es')
		%w( translatable_id position parent_id title body hide_menu 
			).each do |attr|
			assert_equal child_en.send(attr), child_es.send(attr)
		end
	end

	test "should create translation of page with locale parent" do
		parent_en = create_page
		parent_es = parent_en.translate('es')
		child_en = create_page(:parent_id => parent_en.id)
		child_es = child_en.translate('es')
		%w( translatable_id position title body hide_menu 
			).each do |attr|
			assert_equal child_en.send(attr), child_es.send(attr)
			assert_equal parent_en.send(attr), parent_es.send(attr)
		end
		assert_not_equal child_en.parent_id, child_es.parent_id
		assert_equal child_es.parent_id, parent_es.id
	end

	test "should create translation of page with locale child" do
		parent_en = create_page
		child_en = create_page(:parent_id => parent_en.id)
		child_es = child_en.translate('es')
		parent_es = parent_en.translate('es')
		%w( translatable_id position title body hide_menu 
			).each do |attr|
			assert_equal child_en.send(attr), child_es.send(attr)
			assert_equal parent_en.send(attr), parent_es.send(attr)
		end
		assert_not_equal child_en.parent_id, child_es.reload.parent_id
		assert_equal child_es.parent_id, parent_es.id
	end

	test "should sync position on original change" do
		p = create_page
		t = p.translate('es')
		assert_equal p.position, t.position
		p.update_attribute(:position, 42)
		assert_equal p.reload.position, t.reload.position
	end

	test "should sync hide_menu on original change" do
		p = create_page
		t = p.translate('es')
		assert_equal p.hide_menu, t.hide_menu
		p.update_attribute(:hide_menu, true)
		assert_equal p.reload.hide_menu, t.reload.hide_menu
	end

	test "should sync position on translation change" do
		p = create_page
		t = p.translate('es')
		assert_equal p.position, t.position
		t.update_attribute(:position, 42)
		assert_equal p.reload.position, t.reload.position
	end

	test "should sync hide_menu on translation change" do
		p = create_page
		t = p.translate('es')
		assert_equal p.hide_menu, t.hide_menu
		t.update_attribute(:hide_menu, true)
		assert_equal p.reload.hide_menu, t.reload.hide_menu
	end

	test "should find page by path" do
		p = create_page
		page = Page.by_path(p.path)
		assert_equal p, page
	end

	test "should find page by path and locale" do
		p = create_page
		page = Page.by_path(p.path, p.locale)
		assert_equal p, page
	end

	test "should find page by path and nil locale" do
		p = create_page
		page = Page.by_path(p.path, nil)
		assert_equal p, page
	end

	test "should find page by path and non-existant locale" do
		p = create_page
		page = Page.by_path(p.path, 'zz')
		assert_equal p, page
	end

	test "should find translation of page by path and existant locale" do
		p = create_page
		t = p.translate('es')
		page = Page.by_path(p.path, 'es')
		assert_equal t, page
	end

	test "should adjust translations parent" do
		parent_en = create_page
		parent_es = parent_en.translate('es')
		child_en = create_page(:parent_id => parent_en.id)
		child_es = child_en.translate('es')
		assert_equal child_es.parent_id, parent_es.id
		new_parent_en = create_page
		new_parent_es = new_parent_en.translate('es')
		child_en.parent = new_parent_en
		child_en.save
		assert_equal child_es.reload.parent_id, new_parent_es.id
	end

	test "should find locale parent on translation update" do
		parent_en = create_page
		parent_es = parent_en.translate('es')
		child_en = create_page
		child_es = child_en.translate('es')
		child_es.update_attribute(:parent_id, parent_es.id)
		assert_equal parent_es.reload.id, child_es.reload.parent_id
		assert_equal parent_en.reload.id, child_en.reload.parent_id
		assert_not_nil child_es.reload.parent_id
		assert_not_nil child_en.reload.parent_id
	end

protected

	def create_page(options = {})
		record = Factory.build(:page,options)
		record.save
		record
	end

end

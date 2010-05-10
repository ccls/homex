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

	test "should require menu_en" do
		assert_no_difference 'Page.count' do
			page = create_page(:menu => nil)
			assert page.errors.on(:menu_en)
		end
	end

	test "should require unique menu_en" do
		p = create_page
		assert_no_difference 'Page.count' do
			page = create_page(:menu => p.menu)
			assert page.errors.on(:menu_en)
		end
	end

	test "should require 4 char menu_en" do
		assert_no_difference 'Page.count' do
			page = create_page(:menu => 'Hey')
			assert page.errors.on(:menu_en)
		end
	end

	test "should require title_en" do
		assert_no_difference 'Page.count' do
			page = create_page(:title => nil)
			assert page.errors.on(:title_en)
		end
	end

	test "should require 4 char title_en" do
		assert_no_difference 'Page.count' do
			page = create_page(:title => 'Hey')
			assert page.errors.on(:title_en)
		end
	end

	test "should require body_en" do
		assert_no_difference 'Page.count' do
			page = create_page(:body => nil)
			assert page.errors.on(:body_en)
		end
	end

	test "should require 4 char body_en" do
		assert_no_difference 'Page.count' do
			page = create_page(:body => 'Hey')
			assert page.errors.on(:body_en)
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

	test "should find page by path" do
		p = create_page
		page = Page.by_path(p.path)
		assert_equal p, page
	end

	test "should return english menu without locale" do
		p = create_page
		assert_equal p.menu, p.menu_en
	end

	test "should return english title without locale" do
		p = create_page
		assert_equal p.title, p.title_en
	end

	test "should return english body without locale" do
		p = create_page
		assert_equal p.body, p.body_en
	end

	test "should return english menu with locale" do
		p = create_page
		assert_equal p.menu('en'), p.menu_en
	end

	test "should return english title with locale" do
		p = create_page
		assert_equal p.title('en'), p.title_en
	end

	test "should return english body with locale" do
		p = create_page
		assert_equal p.body('en'), p.body_en
	end

	test "should return spanish menu with locale" do
		p = create_page(:menu_es => 'spanish menu')
		assert_equal p.menu('es'), p.menu_es
	end

	test "should return spanish title with locale" do
		p = create_page(:title_es => 'spanish title')
		assert_equal p.title('es'), p.title_es
	end

	test "should return spanish body with locale" do
		p = create_page(:body_es => 'spanish body')
		assert_equal p.body('es'), p.body_es
	end

	test "should return english menu with missing spanish locale" do
		p = create_page(:menu_es => '')
		assert_equal p.menu('es'), p.menu_en
	end

	test "should return english title with missing spanish locale" do
		p = create_page(:title_es => '')
		assert_equal p.title('es'), p.title_en
	end

	test "should return english body with missing spanish locale" do
		p = create_page(:body_es => '')
		assert_equal p.body('es'), p.body_en
	end

protected

	def create_page(options = {})
		record = Factory.build(:page,options)
		record.save
		record
	end

end

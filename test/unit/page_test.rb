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

	test "should require 4 char path" do
		assert_no_difference 'Page.count' do
			page = create_page(:path => 'Hey')
			assert page.errors.on(:path)
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

protected

	def create_page(options = {})
		record = Factory.build(:page,options)
		record.save
		record
	end

end

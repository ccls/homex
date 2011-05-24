require 'test_helper'

class SubjectsHelperTest < ActionView::TestCase

#	id_bar_for

	test "should respond to subject_id_bar" do
		assert respond_to?(:subject_id_bar)
	end

#	sort_link

	test "should respond to sort_link" do
		assert respond_to?(:sort_link)
	end

	test "should return div with link to sort column name" do
		#	NEED controller and action as method calls link_to which requires them
		self.params = { :controller => 'subjects', :action => 'index' }
		response = HTML::Document.new(sort_link('name')).root
		#	<div class=""><a href="/subjects?dir=asc&amp;order=name">name</a></div>
		assert_select response, 'div', 1 do
			assert_select 'a', 1
			assert_select 'span', 0
		end
	end

	test "should return div with link to sort column name with order set to name" do
		self.params = { :controller => 'subjects', :action => 'index', 
			:order => 'name' }
		response = HTML::Document.new(sort_link('name')).root
		#	<div class="sorted"><a href="/subjects?dir=asc&amp;order=name">name</a>
		#		<span class="up arrow">&uarr;</span></div>
		assert_select response, 'div.sorted', 1 do
			assert_select 'a', 1
			assert_select 'span.up.arrow', 1
		end
	end

	test "should return div with link to sort column name with order set to name" <<
			" and dir set to 'asc'" do
		self.params = { :controller => 'subjects', :action => 'index', 
			:order => 'name', :dir => 'asc' }
		response = HTML::Document.new(sort_link('name')).root
		#	<div class="sorted"><a href="/subjects?dir=asc&amp;order=name">name</a>
		#		<span class="down arrow">&uarr;</span></div>
		assert_select response, 'div.sorted', 1 do
			assert_select 'a', 1
			assert_select 'span.down.arrow', 1
		end
	end

	test "should return div with link to sort column name with order set to name" <<
			" and dir set to 'desc'" do
		self.params = { :controller => 'subjects', :action => 'index', 
			:order => 'name', :dir => 'desc' }
		response = HTML::Document.new(sort_link('name')).root
		#	<div class="sorted"><a href="/subjects?dir=asc&amp;order=name">name</a>
		#		<span class="up arrow">&uarr;</span></div>
		assert_select response, 'div.sorted', 1 do
			assert_select 'a', 1
			assert_select 'span.up.arrow', 1
		end
	end

private 
	def params
		@params || {}
	end
	def params=(new_params)
		@params = new_params
	end
end

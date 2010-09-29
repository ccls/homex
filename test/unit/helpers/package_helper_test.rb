require File.dirname(__FILE__) + '/../../test_helper'

class PackageHelperTest < ActionView::TestCase

	test "tracks_for requires valid package" do
		assert_raise(NoMethodError){
			tracks_for(nil)
		}
	end

	test "tracks_for should return div#tracks" do
		package = Factory(:package)
		response = HTML::Document.new(tracks_for(package)).root
		assert_select response, 'div#tracks', 1
	end

end

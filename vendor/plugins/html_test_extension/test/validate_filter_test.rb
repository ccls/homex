require File.dirname(__FILE__) + '/test_helper'

class ValidateFilterTest < ActiveSupport::TestCase

	def setup
		Html::Test::Validator.revalidate_all = true
		Html::Test::ValidateFilter.clear_validated_urls
		#	class variables remember these validated urls
		#	so we need to reset them or use a different
		#	one for each test.
	end

	test "revalidate_all is true by default" do
		assert Html::Test::Validator.revalidate_all
	end

	test "already_validated? returns false by default" do
		Html::Test::Validator.revalidate_all = false
		assert !Html::Test::ValidateFilter.already_validated?(
			'/controller/action')
	end

	test "already_validated? returns false if have by default" do
		url = '/controller/action'
		assert !Html::Test::ValidateFilter.already_validated?(url)
		Html::Test::ValidateFilter.mark_url_validated(url)
		assert !Html::Test::ValidateFilter.already_validated?(url)
	end

	test "already_validated? returns true if have when not revalidating" do
		Html::Test::Validator.revalidate_all = false
		url = '/controller/action'
		assert !Html::Test::ValidateFilter.already_validated?(url)
		Html::Test::ValidateFilter.mark_url_validated(url)
		assert Html::Test::ValidateFilter.already_validated?(url)
	end

	test "already_validated? returns false when revalidate_all is false and not validated yet" do
		Html::Test::Validator.revalidate_all = false
		assert !Html::Test::ValidateFilter.already_validated?(
			'/controller/action')
	end

	test "already_validated? returns false when revalidate_all is true and not validated yet" do
		Html::Test::Validator.revalidate_all = true
		assert !Html::Test::ValidateFilter.already_validated?(
			'/controller/action')
	end

end

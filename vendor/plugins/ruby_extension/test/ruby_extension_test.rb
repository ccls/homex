require 'test/unit'
require 'rubygems'
require 'uri'
#require 'active_support/core_ext'
require 'active_support'
require 'active_support/test_case'

$:.unshift "#{File.dirname(__FILE__)}/../lib"
require "#{File.dirname(__FILE__)}/../rails/init"

class RubyExtensionTest < ActiveSupport::TestCase

#	Nil

	test "should split nil and return empty array" do
		assert_equal [], nil.split()
	end

#	Array

	test "should arrange array" do
		assert_equal ["c", "a", "b"], ['a','b','c'].arrange([2,0,1])
	end

	test "should drop empty strings from array" do
		x = [0,1,'zero','one','']
		y = x.drop_blanks!
		assert_equal [0,1,'zero','one'], x
		assert_equal [0,1,'zero','one'], y
	end

	test "should drop nils from array" do
		x = [0,1,'zero','one',nil]
		y = x.drop_blanks!
		assert_equal [0,1,'zero','one'], x
		assert_equal [0,1,'zero','one'], y
	end

	test "should capitalize! all strings in existing array" do
		x = ['foo','bar']
		y = x.capitalize!
		assert_equal ['Foo','Bar'], x
		assert_equal ['Foo','Bar'], y
	end

	test "should capitalize all strings in new array" do
		x = ['foo','bar']
		y = x.capitalize
		assert_equal ['foo','bar'], x		#	no change to original
		assert_equal ['Foo','Bar'], y
	end

	test "should downcase all strings in new array" do
		x = ['FOO','BAR']
		y = x.downcase
		assert_equal ['FOO','BAR'], x		#	no change to original
		assert_equal ['foo','bar'], y
	end

	test "should numericize/digitize" do
		x = ['foo', 'bar', 0, '42', '-0.4', nil]
		y = x.numericize
		assert_equal ['foo', 'bar', 0, '42', '-0.4', nil], x
		assert_equal [0.0, 0.0, 0.0, 42, -0.4, 0.0], y
	end

	test "should compute sum" do
		x = ['foo', 'bar', 0, '42', '-0.4', nil]
		y = x.numericize.sum
		assert_equal ['foo', 'bar', 0, '42', '-0.4', nil], x
		assert_equal 41.6, y
	end

	test "should compute average" do
		x = [ 1, 1, 4 ]
		y = x.average
		assert_equal 2.0, y
	end

	test "should compute median" do
		x = [ 1, 1, 4 ]
		y = x.median
		assert_equal 1, y
	end

	test "should swap values based on indexes" do
		x = %w( apple banana orange )
		y = x.swap_indexes(0,2)
		assert_equal %w( apple banana orange ), x
		assert_equal %w( orange banana apple ), y
	end

	test "should swap! values based on indexes" do
		x = %w( apple banana orange )
		y = x.swap_indexes!(0,2)
		assert_equal %w( orange banana apple ), x
		assert_equal %w( orange banana apple ), y
	end

	test "should find first index via argument" do
		x = %w( apple banana orange )
		assert_equal 1, x.first_index('banana')
	end

	test "should find first index via block" do
		x = %w( apple banana orange )
		assert_equal 1, x.first_index{|i| i == 'banana'}
	end

	test "should return nil for first index with empty array" do
		assert_nil [].first_index('banana')
	end

	test "should return nil for first index with no match" do
		x = %w( apple banana orange )
		assert_nil x.first_index('pineapple')
	end

#	String

	test "should convert url query string to hash" do
		h = {'foo' => '1', 'bar' => '2'}
		assert_equal h, "foo=1&bar=2".to_params_hash
	end

	test "should return self in response to uniq" do
		assert_equal "foobar", "foobar".uniq
	end

#	Integer

	test "should return 5 factorial" do
		assert_equal 120, 5.factorial
	end

	test "should return 0 factorial" do
		assert_equal 0, 0.factorial
	end

	test "should return -3 factorial" do
		assert_equal -3, -3.factorial
	end

end

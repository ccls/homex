require File.dirname(__FILE__) + '/test_helper'

class ActsAsTrackableTest < ActiveSupport::TestCase

	def setup
		setup_db
	end

	def teardown
		teardown_db
	end

	test "should create book" do
		assert_difference 'Book.count' do
			book = create_book
			assert !book.new_record?, 
				"#{book.errors.full_messages.to_sentence}"
		end
	end

	test "should require tracking_number" do
		assert_no_difference 'Book.count' do
			book = create_book(:tracking_number => nil)
			assert book.errors.on(:tracking_number)
		end
	end

	test "should require 3 char tracking_number" do
		assert_no_difference 'Book.count' do
			book = create_book(:tracking_number => 'Hi')
			assert book.errors.on(:tracking_number)
		end
	end

	test "should require unique tracking_number" do
		b = create_book
		assert_no_difference 'Book.count' do
			book = create_book(:tracking_number => b.tracking_number)
			assert book.errors.on(:tracking_number)
		end
	end

	test "should have many tracks" do
		book = create_book
		assert_equal 0, book.tracks.length
		book.tracks.create!( :name => 'name', :time => Time.now - 10000 )
		assert_equal 1, book.reload.tracks.length
		assert_equal 1, book.reload.tracks_count
		book.tracks.create!( :name => 'name', :time => Time.now )
		assert_equal 2, book.reload.tracks.length
		assert_equal 2, book.reload.tracks_count
	end

	test "should mass assign tracking number when attr_accessible not used" do
		assert_difference 'Book.count' do
			book = Book.new({ :tracking_number => '123' })
			book.save
			assert !book.new_record?, 
				"#{book.errors.full_messages.to_sentence}"
		end
	end

	test "should mass assign tracking number when attr_accessible used" do
		assert_difference 'Package.count' do
			package = Package.new({ :tracking_number => '123' })
			package.save
			assert !package.new_record?, 
				"#{package.errors.full_messages.to_sentence}"
		end
	end

end

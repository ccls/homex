require File.dirname(__FILE__) + '/../test_helper'

class LanguageTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:interviews,:instrument_versions)
	assert_should_require(:code,:description)
	assert_should_require_unique(:code,:description)

#  test "should create language" do
#		assert_difference( "#{model_name}.count", 1 ) do
#      object = create_object
#      assert !object.new_record?,
#        "#{object.errors.full_messages.to_sentence}"
#    end
#  end

  test "should require 4 char description" do
		assert_difference( "#{model_name}.count", 0 ) do
      object = create_object(:description => 'Hey')
      assert object.errors.on(:description)
    end 
  end 

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

	test "should find random" do
		object = Language.random()
		assert object.is_a?(Language)
	end

	test "should return nil on random when no records" do
		Language.stubs(:count).returns(0)
		object = Language.random()
		assert_nil object
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class LanguageTest < ActiveSupport::TestCase

  test "should create language" do
    assert_difference 'Language.count' do
      object = create_object
      assert !object.new_record?,
        "#{object.errors.full_messages.to_sentence}"
    end
  end

  test "should require code" do
    assert_no_difference 'Language.count' do
      object = create_object(:code => nil)
      assert object.errors.on(:code)
    end
  end

  test "should require unique code" do
    se = create_object
    assert_no_difference 'Language.count' do
      object = create_object(
        :code => se.code)
      assert object.errors.on(:code)
    end 
  end 

  test "should require description" do
    assert_no_difference 'Language.count' do
      object = create_object(:description => nil)
      assert object.errors.on(:description)
    end 
  end 

  test "should require 4 char description" do
    assert_no_difference 'Language.count' do
      object = create_object(:description => 'Hey')
      assert object.errors.on(:description)
    end 
  end 

  test "should require unique description" do
    se = create_object
    assert_no_difference 'Language.count' do
      object = create_object(
        :description => se.description)
      assert object.errors.on(:description)
    end 
  end 

	test "should have many interview_versions" do
		object = create_object
		assert_equal 0, object.interview_versions.length
		Factory(:interview_version, :language_id => object.id)
		assert_equal 1, object.reload.interview_versions.length
		Factory(:interview_version, :language_id => object.id)
		assert_equal 2, object.reload.interview_versions.length
	end

	test "should have many interviews" do
		object = create_object
		assert_equal 0, object.interviews.length
		Factory(:interview, :language_id => object.id)
		assert_equal 1, object.reload.interviews.length
		Factory(:interview, :language_id => object.id)
		assert_equal 2, object.reload.interviews.length
	end

	test "should act as list" do
		object = create_object
		assert_equal 1, object.position
		object = create_object
		assert_equal 2, object.position
	end

protected

  def create_object(options = {}) 
    record = Factory.build(:language,options)
    record.save
    record
  end 

end

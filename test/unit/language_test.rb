require File.dirname(__FILE__) + '/../test_helper'

class LanguageTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:interviews,:interview_versions)

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

protected

  def create_object(options = {}) 
    record = Factory.build(:language,options)
    record.save
    record
  end 

end

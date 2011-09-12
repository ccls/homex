require 'test_helper'

class GiftCardsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'GiftCard',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_gift_card
	}
	def factory_attributes(options={})
		Factory.attributes_for(:gift_card,options)
	end

	assert_access_with_login({ 
		:logins => site_administrators })
	assert_no_access_with_login({ 
		:logins => non_site_administrators })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

#	TODO duplicate?
	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :gift_cards_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	)

	site_administrators.each do |cu|

#	TODO duplicate?
		test "should NOT create new gift_card with #{cu} login when create fails" do
			GiftCard.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			assert_difference('GiftCard.count',0) do
				post :create, :gift_card => factory_attributes
			end
			assert assigns(:gift_card)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

#	TODO duplicate?
		test "should NOT create new gift_card with #{cu} login and invalid gift_card" do
			GiftCard.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			assert_difference('GiftCard.count',0) do
				post :create, :gift_card => factory_attributes
			end
			assert assigns(:gift_card)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

#	TODO duplicate?
		test "should NOT update gift_card with #{cu} login when update fails" do
			gift_card = create_gift_card(:updated_at => Chronic.parse('yesterday'))
			GiftCard.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			deny_changes("GiftCard.find(#{gift_card.id}).updated_at") {
				put :update, :id => gift_card.id,
					:gift_card => factory_attributes
			}
			assert assigns(:gift_card)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

#	TODO duplicate?
		test "should NOT update gift_card with #{cu} login and invalid gift_card" do
			gift_card = create_gift_card(:updated_at => Chronic.parse('yesterday'))
			GiftCard.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			deny_changes("GiftCard.find(#{gift_card.id}).updated_at") {
				put :update, :id => gift_card.id,
					:gift_card => factory_attributes
			}
			assert assigns(:gift_card)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

	end

end

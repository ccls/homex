require File.dirname(__FILE__) + '/../../test_helper'

class He::SubjectsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_subject

	test "should get index with subjects" do
		survey = Survey.find_by_access_code("home_exposure_survey")
		rs1 = fill_out_survey(:survey => survey)
		rs2 = fill_out_survey(:survey => survey, :subject => rs1.subject)
		rs2.to_her
		rs3 = fill_out_survey(:survey => survey)
		rs4 = fill_out_survey(:survey => survey, :subject => rs3.subject)
		rs5 = fill_out_survey(:survey => survey)
		Factory(:study_event)	#	test search code in view
		#	There should now be 4 subjects in different states.
		login_as admin_user
		get :index
		assert_equal 1, assigns(:subjects).length
		assert_response :success
		assert_template 'index'
	end

	test "should get index with admin login" do
		login_as admin_user
		get :index
		assert_response :success
		assert_template 'index'
	end

	test "should get index with employee login" do
		login_as employee
		get :index
		assert_response :success
		assert_template 'index'
	end

	test "should NOT get index with just login" do
		login_as active_user
		get :index
		assert_redirected_to root_path
	end

	test "should NOT get index without login" do
		get :index
		assert_redirected_to_login
	end

	test "should download csv with admin login" do
		login_as admin
		get :index, :commit => 'download'
		assert_response :success
		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
	end

	test "should get show with admin login" do
		subject = Factory(:subject)
		login_as admin_user
		get :show, :id => subject
		assert_response :success
		assert_template 'show'
	end

	test "should get show with pii" do
		subject = Factory(:subject,
			:pii_attributes => Factory.attributes_for(:pii))
		login_as admin_user
		get :show, :id => subject
		assert_response :success
		assert_template 'show'
	end

	test "should get show with employee login" do
		subject = Factory(:subject)
		login_as employee
		get :show, :id => subject
		assert_response :success
		assert_template 'show'
	end

	test "should NOT get show with just login" do
		subject = Factory(:subject)
		login_as active_user
		get :show, :id => subject
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get show without login" do
		subject = Factory(:subject)
		get :show, :id => subject
		assert_redirected_to_login
	end

	test "should NOT get show with invalid id" do
		subject = Factory(:subject)
		login_as admin
		get :show, :id => 0
		assert_not_nil flash[:error]
		assert_redirected_to he_subjects_path
	end




#		test "should get new with admin login" do
#			login_as admin
#			get :new
#			assert_response :success
#			assert_template 'new'
#		end
#	
#		test "should get new with employee login" do
#			login_as employee
#			get :new
#			assert_response :success
#			assert_template 'new'
#		end
#	
#		test "should NOT get new with just login" do
#			login_as user
#			get :new
#			assert_redirected_to root_path
#		end
#	
#		test "should NOT get new without login" do
#			get :new
#			assert_redirected_to_login
#		end
#	
#		test "new subject should have non nil pii" do
#			login_as admin
#			get :new
#			assert_not_nil assigns(:subject)
#			assert_not_nil assigns(:subject).pii
#		end
#	
#		
#		test "should create with admin login" do
#			login_as admin
#			Factory(:race)
#			Factory(:subject_type)
#			assert_difference('Subject.count',1){
#				post :create, :subject => Factory.attributes_for(:subject,
#					:race_id => Race.first.id,
#					:subject_type_id => SubjectType.first.id)
#			}
#			assert_redirected_to subject_path(assigns(:subject))
#		end
#	
#		test "should create with employee login" do
#			login_as employee
#			Factory(:race)
#			Factory(:subject_type)
#			assert_difference('Subject.count',1){
#				post :create, :subject => Factory.attributes_for(:subject,
#					:race_id => Race.first.id,
#					:subject_type_id => SubjectType.first.id)
#			}
#			assert_redirected_to subject_path(assigns(:subject))
#		end
#	
#		test "should NOT create with just login" do
#			login_as user
#			Factory(:race)
#			Factory(:subject_type)
#			assert_difference('Subject.count',0){
#				post :create, :subject => Factory.attributes_for(:subject,
#					:race_id => Race.first.id,
#					:subject_type_id => SubjectType.first.id)
#			}
#			assert_not_nil flash[:error]
#			assert_redirected_to root_path
#		end
#	
#		test "should NOT create without login" do
#			Factory(:race)
#			Factory(:subject_type)
#			post :create, :subject => Factory.attributes_for(:subject,
#				:race_id => Race.first.id,
#				:subject_type_id => SubjectType.first.id)
#			assert_redirected_to_login
#		end
#	
#		test "should NOT create with invalid subject" do
#			pending
#	#
#	#	subject has no validations so cannot test yet
#	#
#	#		login_as admin
#	#		Factory(:race)
#	#		Factory(:subject_type)
#	#		assert_difference('Subject.count',0){
#	#			post :create, :subject => {
#	#				:race_id => Race.first.id,
#	#				:subject_type_id => SubjectType.first.id}
#	#		}
#	#		assert_response :success
#	#		assert_template 'new'
#	#		assert_not_nil flash[:error]
#		end
#	
#		test "should NOT create without subject_type" do
#			login_as admin
#			Factory(:race)
#			Factory(:subject_type)
#			assert_difference('Subject.count',0){
#				post :create, :subject => Factory.attributes_for(:subject,
#					:race_id => Race.first.id)
#			}
#			assert_response :success
#			assert_template 'new'
#			assert_not_nil flash[:error]
#		end
#	
#		test "should NOT create without race" do
#			login_as admin
#			Factory(:race)
#			Factory(:subject_type)
#			assert_difference('Subject.count',0){
#				post :create, :subject => Factory.attributes_for(:subject,
#					:subject_type_id => SubjectType.first.id)
#			}
#			assert_response :success
#			assert_template 'new'
#			assert_not_nil flash[:error]
#		end
#	
#		test "should NOT create without valid subject_type" do
#			login_as admin
#			Factory(:race)
#			Factory(:subject_type)
#			assert_difference('Subject.count',0){
#				post :create, :subject => Factory.attributes_for(:subject,
#					:subject_type_id => 0,
#					:race_id => Race.first.id)
#			}
#			assert_response :success
#			assert_template 'new'
#			assert_not_nil flash[:error]
#		end
#	
#		test "should NOT create without valid race" do
#			login_as admin
#			Factory(:race)
#			Factory(:subject_type)
#			assert_difference('Subject.count',0){
#				post :create, :subject => Factory.attributes_for(:subject,
#					:race_id => 0,
#					:subject_type_id => SubjectType.first.id)
#			}
#			assert_response :success
#			assert_template 'new'
#			assert_not_nil flash[:error]
#		end



	test "should edit with admin login" do
		subject = Factory(:subject)
		login_as admin
		get :edit, :id => subject.id
		assert_response :success
		assert_template 'edit'
	end

	test "should edit with employee login" do
		subject = Factory(:subject)
		login_as employee
		get :edit, :id => subject.id
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT edit with just login" do
		subject = Factory(:subject)
		login_as user
		get :edit, :id => subject.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT edit without login" do
		subject = Factory(:subject)
		get :edit, :id => subject.id
		assert_redirected_to_login
	end

	test "should NOT edit without valid id" do
		subject = Factory(:subject)
		login_as admin
		get :edit, :id => 0
		assert_not_nil flash[:error]
		assert_redirected_to he_subjects_path
	end



	test "should update with admin login" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id, 
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_redirected_to he_subject_path(assigns(:subject))
	end

	test "should update with employee login" do
		subject = Factory(:subject)
		login_as employee
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id, 
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_redirected_to he_subject_path(assigns(:subject))
	end

	test "should NOT update with just login" do
		subject = Factory(:subject)
		login_as user
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id, 
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT update without login" do
		subject = Factory(:subject)
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id, 
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_redirected_to_login
	end

	test "should NOT update with invalid id" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => 0,
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_not_nil flash[:error]
		assert_redirected_to he_subjects_path
	end

	test "should NOT update without subject_type_id" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id,
				:subject => { :subject_type_id => nil }
		} } }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT update without race_id" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id,
				:subject => { :race_id => nil }
		} } }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT update without valid subject_type_id" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id,
				:subject => { :subject_type_id => 0 }
		} } }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT update without valid race_id" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id,
				:subject => { :race_id => 0 }
		} } }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end



	test "should destroy with admin login" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',-1) {
			delete :destroy, :id => subject.id
		}
		assert_redirected_to he_subjects_path
	end

	test "should destroy with employee login" do
		subject = Factory(:subject)
		login_as employee
		assert_difference('Subject.count',-1) {
			delete :destroy, :id => subject.id
		}
		assert_redirected_to he_subjects_path
	end

	test "should NOT destroy with just login" do
		subject = Factory(:subject)
		login_as user
		assert_difference('Subject.count',0) {
			delete :destroy, :id => subject.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT destroy without login" do
		subject = Factory(:subject)
		assert_difference('Subject.count',0) {
			delete :destroy, :id => subject.id
		}
		assert_redirected_to_login
	end

	test "should NOT destroy with invalid id" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',0) {
			delete :destroy, :id => 0
		}
		assert_not_nil flash[:error]
		assert_redirected_to he_subjects_path
	end

end

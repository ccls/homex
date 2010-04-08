class SurveyInvitationsController < ApplicationController
	before_filter :may_create_invitations_required, :only => :create
	before_filter :valid_subject_id_required, :only => :create
	before_filter :valid_survey_required, :only => :create

	before_filter :valid_invitation_token_required, :only => :show

	def create
		invitation = @subject.recreate_survey_invitation(@survey)
		if invitation.new_record?
			flash[:error] = "There was a problem creating the invitation!"
		else
			flash[:notice] = "The invitation was successfully created."
		end
		redirect_to @subject
	end

	def show


	end

protected

	def valid_subject_id_required
		if( Subject.exists?( params[:subject_id] ) )
			@subject = Subject.find( params[:subject_id] )
		else
			access_denied("Valid Subject ID required")
		end
	end

	def valid_invitation_token_required
		if( SurveyInvitation.exists?( :token => params[:id] ) )
			@invitation = SurveyInvitation.first(:conditions => {
				:token => params[:id] })
		else
			access_denied("Valid Invitation required")
		end
	end

	def valid_survey_required
		if( Survey.exists?( params[:survey_id] ) )
			@survey = Survey.find( params[:survey_id] )
		elsif( Survey.exists?( :access_code => params[:access_code] ) )
			@survey = Survey.find( :first, :conditions => {
				:access_code => params[:access_code] })
		elsif( Survey.exists?( :access_code => params[:survey_code] ) )
			@survey = Survey.find( :first, :conditions => {
				:access_code => params[:survey_code] })
		else
			access_denied("Valid Survey ID required")
		end
	end

end

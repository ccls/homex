class HomeExposureResponsesController < ApplicationController #:nodoc:

	before_filter :may_view_responses_required
	before_filter :valid_subject_id_required
	before_filter :her_must_not_exist, :only => [:new,:create]
	before_filter :her_must_exist, :only => [:show]
	before_filter :two_response_sets_required, :only => [:new,:create]
	before_filter :all_response_sets_completed_required, :only => [:new,:create]
#	before_filter :valid_response_set_id_required, :only => :create
	before_filter :home_exposure_response_attributes_required, :only => :create

	def new
		@response_sets = @subject.response_sets
#		@diffs = @response_sets.inject(:diff)
#		@diffs = @response_sets[0].diff(@response_sets[1])
		@diffs = @subject.response_set_diffs
	end

	def create
#		@her = @response_set.to_her
		@her = @subject.create_home_exposure_response(
			params[:home_exposure_response] )
		if @her.new_record?
			flash.now[:error] = "There was a problem creating HER"
			new
			render :action => 'new'
		else
#			redirect_to subjects_path
			redirect_to subject_home_exposure_response_path(@subject)
		end
	end

	def show
		@home_exposure_response = HomeExposureResponse.find(:first,
			:conditions => { :subject_id => @subject.id }
		)
	end

protected

	def home_exposure_response_attributes_required
		if params[:home_exposure_response].nil? ||
			!params[:home_exposure_response].is_a?(Hash)
			access_denied("home exposure response attributes hash required")
		end
	end

	def her_must_exist
		unless HomeExposureResponse.exists?(:subject_id => params[:subject_id] )
			access_denied("HER does not exist for this subject")
		end
	end

	def her_must_not_exist
		if HomeExposureResponse.exists?(:subject_id => params[:subject_id] )
			access_denied("HER already exists for this subject")
		end
	end

	def valid_subject_id_required
		if( Subject.exists?( params[:subject_id] ) )
			@subject = Subject.find( params[:subject_id] )
		else
			access_denied("Valid Subject ID required")
		end
	end

	def two_response_sets_required
		if @subject.response_sets.count > 2 ||
			@subject.response_sets.count < 2
			access_denied("Must complete 2 response sets before merging. " <<
				":#{@subject.response_sets.count}:" )
		end
	end

	def all_response_sets_completed_required
		unless @subject.response_sets.collect(&:is_complete?).all?
			access_denied("All response sets need to be completed")
		end
	end

#	def valid_response_set_id_required
#		if( @subject.response_sets.exists?( params[:response_set_id] ) )
#			@response_set = ResponseSet.find( params[:response_set_id] )
#		else
#			access_denied("Valid ResponseSet ID required")
#		end
#	end


#  # GET /home_exposure_responses/1/edit
#  def edit
#    @home_exposure_response = HomeExposureResponse.find(params[:id])
#  end
#
#  # PUT /home_exposure_responses/1
#  # PUT /home_exposure_responses/1.xml
#  def update
#    @home_exposure_response = HomeExposureResponse.find(params[:id])
#
#    respond_to do |format|
#      if @home_exposure_response.update_attributes(params[:home_exposure_response])
#        flash[:notice] = 'HomeExposureResponse was successfully updated.'
#        format.html { redirect_to(@home_exposure_response) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @home_exposure_response.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /home_exposure_responses/1
#  # DELETE /home_exposure_responses/1.xml
#  def destroy
#    @home_exposure_response = HomeExposureResponse.find(params[:id])
#    @home_exposure_response.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(home_exposure_responses_url) }
#      format.xml  { head :ok }
#    end
#  end
end

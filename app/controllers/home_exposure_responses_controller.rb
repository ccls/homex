class HomeExposureResponsesController < ApplicationController #:nodoc:

	before_filter :may_view_responses_required
	before_filter :valid_subject_id_required
	before_filter :her_must_not_exist, :only => [:new,:create]
	before_filter :her_must_exist, :only => [:show]
	before_filter :two_response_sets_required, :only => [:new,:create]
	before_filter :all_response_sets_completed_required, :only => [:new,:create]
	before_filter :valid_response_set_id_required, :only => :create

	def new
#	works but not what I want
#		@keys = @subject.response_sets.collect(&:q_and_a_codes_as_attributes).collect(&:keys).inject(:|)
	end

	def create
		@her = @response_set.to_her
		if @her.new_record?
			flash.now[:error] = "There was a problem creating HER"
			render :action => 'new'
		else
			redirect_to subjects_path
		end
	end

	def show
		@home_exposure_response = HomeExposureResponse.find(:first,
			:conditions => { :subject_id => @subject.id }
		)
	end

protected

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

	def valid_response_set_id_required
		if( @subject.response_sets.exists?( params[:response_set_id] ) )
			@response_set = ResponseSet.find( params[:response_set_id] )
		else
			access_denied("Valid ResponseSet ID required")
		end
	end


#
#	before_filter :may_view_responses_required
#
#  # GET /home_exposure_responses
#  # GET /home_exposure_responses.xml
#  def index
#    @home_exposure_responses = HomeExposureResponse.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @home_exposure_responses }
#    end
#  end
#
#  # GET /home_exposure_responses/1
#  # GET /home_exposure_responses/1.xml
#  def show
#    @home_exposure_response = HomeExposureResponse.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @home_exposure_response }
#    end
#  end
#
#  # GET /home_exposure_responses/new
#  # GET /home_exposure_responses/new.xml
#  def new
#    @home_exposure_response = HomeExposureResponse.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @home_exposure_response }
#    end
#  end
#
#  # GET /home_exposure_responses/1/edit
#  def edit
#    @home_exposure_response = HomeExposureResponse.find(params[:id])
#  end
#
#  # POST /home_exposure_responses
#  # POST /home_exposure_responses.xml
#  def create
#    @home_exposure_response = HomeExposureResponse.new(params[:home_exposure_response])
#
#    respond_to do |format|
#      if @home_exposure_response.save
#        flash[:notice] = 'HomeExposureResponse was successfully created.'
#        format.html { redirect_to(@home_exposure_response) }
#        format.xml  { render :xml => @home_exposure_response, :status => :created, :location => @home_exposure_response }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @home_exposure_response.errors, :status => :unprocessable_entity }
#      end
#    end
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

class HomeExposureQuestionnairesController < ApplicationController #:nodoc:

	before_filter :may_view_questionnaires_required
	before_filter :valid_subject_id_required
	before_filter :heq_must_not_exist, :only => [:new,:create]
	before_filter :heq_must_exist, :only => [:show]
	before_filter :two_response_sets_required, :only => [:new,:create]
	before_filter :all_response_sets_completed_required, :only => [:new,:create]
	before_filter :valid_response_set_id_required, :only => :create

	def new
#	works but not what I want
#		@keys = @subject.response_sets.collect(&:q_and_a_codes_as_attributes).collect(&:keys).inject(:|)
	end

	def create
		@heq = @response_set.to_heq
		if @heq.new_record?
			flash.now[:error] = "There was a problem creating HEQ"
			render :action => 'new'
		else
			redirect_to subjects_path
		end
	end

	def show
		@home_exposure_questionnaire = HomeExposureQuestionnaire.find(:first,
			:conditions => { :childid => @subject.id }
		)
	end

protected

	def heq_must_exist
		unless HomeExposureQuestionnaire.exists?(:childid => params[:subject_id] )
			access_denied("HEQ does not exist for this subject")
		end
	end

	def heq_must_not_exist
		if HomeExposureQuestionnaire.exists?(:childid => params[:subject_id] )
			access_denied("HEQ already exists for this subject")
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
#	before_filter :may_view_questionnaires_required
#
#  # GET /home_exposure_questionnaires
#  # GET /home_exposure_questionnaires.xml
#  def index
#    @home_exposure_questionnaires = HomeExposureQuestionnaire.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @home_exposure_questionnaires }
#    end
#  end
#
#  # GET /home_exposure_questionnaires/1
#  # GET /home_exposure_questionnaires/1.xml
#  def show
#    @home_exposure_questionnaire = HomeExposureQuestionnaire.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @home_exposure_questionnaire }
#    end
#  end
#
#  # GET /home_exposure_questionnaires/new
#  # GET /home_exposure_questionnaires/new.xml
#  def new
#    @home_exposure_questionnaire = HomeExposureQuestionnaire.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @home_exposure_questionnaire }
#    end
#  end
#
#  # GET /home_exposure_questionnaires/1/edit
#  def edit
#    @home_exposure_questionnaire = HomeExposureQuestionnaire.find(params[:id])
#  end
#
#  # POST /home_exposure_questionnaires
#  # POST /home_exposure_questionnaires.xml
#  def create
#    @home_exposure_questionnaire = HomeExposureQuestionnaire.new(params[:home_exposure_questionnaire])
#
#    respond_to do |format|
#      if @home_exposure_questionnaire.save
#        flash[:notice] = 'HomeExposureQuestionnaire was successfully created.'
#        format.html { redirect_to(@home_exposure_questionnaire) }
#        format.xml  { render :xml => @home_exposure_questionnaire, :status => :created, :location => @home_exposure_questionnaire }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @home_exposure_questionnaire.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /home_exposure_questionnaires/1
#  # PUT /home_exposure_questionnaires/1.xml
#  def update
#    @home_exposure_questionnaire = HomeExposureQuestionnaire.find(params[:id])
#
#    respond_to do |format|
#      if @home_exposure_questionnaire.update_attributes(params[:home_exposure_questionnaire])
#        flash[:notice] = 'HomeExposureQuestionnaire was successfully updated.'
#        format.html { redirect_to(@home_exposure_questionnaire) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @home_exposure_questionnaire.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /home_exposure_questionnaires/1
#  # DELETE /home_exposure_questionnaires/1.xml
#  def destroy
#    @home_exposure_questionnaire = HomeExposureQuestionnaire.find(params[:id])
#    @home_exposure_questionnaire.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(home_exposure_questionnaires_url) }
#      format.xml  { head :ok }
#    end
#  end
end

class HomePagePicsController < ApplicationController
  # GET /home_page_pics
  # GET /home_page_pics.xml
  def index
    @home_page_pics = HomePagePic.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @home_page_pics }
    end
  end

  # GET /home_page_pics/1
  # GET /home_page_pics/1.xml
  def show
    @home_page_pic = HomePagePic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @home_page_pic }
    end
  end

  # GET /home_page_pics/new
  # GET /home_page_pics/new.xml
  def new
    @home_page_pic = HomePagePic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @home_page_pic }
    end
  end

  # GET /home_page_pics/1/edit
  def edit
    @home_page_pic = HomePagePic.find(params[:id])
  end

  # POST /home_page_pics
  # POST /home_page_pics.xml
  def create
    @home_page_pic = HomePagePic.new(params[:home_page_pic])

    respond_to do |format|
      if @home_page_pic.save
        flash[:notice] = 'HomePagePic was successfully created.'
        format.html { redirect_to(@home_page_pic) }
        format.xml  { render :xml => @home_page_pic, :status => :created, :location => @home_page_pic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @home_page_pic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /home_page_pics/1
  # PUT /home_page_pics/1.xml
  def update
    @home_page_pic = HomePagePic.find(params[:id])

    respond_to do |format|
      if @home_page_pic.update_attributes(params[:home_page_pic])
        flash[:notice] = 'HomePagePic was successfully updated.'
        format.html { redirect_to(@home_page_pic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @home_page_pic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /home_page_pics/1
  # DELETE /home_page_pics/1.xml
  def destroy
    @home_page_pic = HomePagePic.find(params[:id])
    @home_page_pic.destroy

    respond_to do |format|
      format.html { redirect_to(home_page_pics_url) }
      format.xml  { head :ok }
    end
  end
end

class PostsController < ApplicationController

	before_filter :id_required, :only => [ :edit, :update, :destroy, :show ]
	before_filter :may_create_post_required, :only => [ :new, :create ]
	before_filter :may_update_post_required, :only => [ :edit, :update ]
	before_filter :may_destroy_post_required, :only => [ :destroy ]

	def new
		@post = current_user.posts.new
		render :text => ''
	end

	def create
		@post = current_user.posts.create
		render :text => ''
	end

	def edit
		render :text => ''
	end

	def update
		render :text => ''
	end

	def destroy
		@post.destroy
		render :text => ''
	end

	def show
		render :text => ''
	end

	def index
		@posts = Post.all
		render :text => ''
	end

protected

	def id_required
		if !params[:id].blank? and Post.exists?(params[:id])
			@post = Post.find(params[:id])
		else
			flash[:error] = "Valid id required."
			redirect_to( posts_path )
		end
	end

end

ActionController::Routing::Routes.draw do |map|

	# The priority is based upon order of creation: first created -> highest priority.

	# Sample of regular route:
	#	 map.connect 'products/:id', :controller => 'catalog', :action => 'view'
	# Keep in mind you can assign values other than :controller and :action

	# Sample of named route:
	#	 map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
	# This route can be invoked with purchase_url(:id => product.id)

	# Sample resource route (maps HTTP verbs to controller actions automatically):
	#	 map.resources :products

	# Sample resource route with options:
	#	 map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

	# Sample resource route with sub-resources:
	#	 map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
	
	# Sample resource route with more complex sub-resources
	#	 map.resources :products do |products|
	#		 products.resources :comments
	#		 products.resources :sales, :collection => { :recent => :get }
	#	 end

	# Sample resource route within a namespace:
	#	 map.namespace :admin do |admin|
	#		 # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
	#		 admin.resources :products
	#	 end

	# You can have the root of your site routed with map.root -- just remember to delete public/index.html.
	# map.root :controller => "welcome"

	# See how all your routes lay out with "rake routes"





	map.root :controller => "pages", :action => "show", :path => [""]



#	map.login  'login',  :controller => 'user_sessions', :action => 'new'  
#	map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'  
#	#	keep user_sessions route plural or form on 'new' will fail.
#	map.resources :user_sessions, :only => [ :new, :create, :destroy ]

	map.logout 'logout', :controller => 'sessions', :action => 'destroy'
	map.resources :sessions, :only => [ :destroy ]


	map.resource  :calendar,   :only => [ :show ]

	map.resources :users, :only => [:show, :index] do |user|
		user.resources :roles, :only => [:update,:destroy]
	end

	map.resources :pages, :collection => { :order => :post }
	map.resources :home_page_pics, :collection => { :activate => :post }
	map.resources :packages, :except => :edit, 
		:member => { :ship => :put, :deliver => :put }
#	map.resources :permissions, :only => :index
	map.resources :response_sets, :only => [ :create ]

	map.resource :home_exposure, :only => :show
	map.namespace :hx do |hx|
		hx.resources :subjects, #:except => [:new,:create],
#			:member => { :general => :get },
			:shallow => true do |subject|
			subject.resource :dust_kit
			subject.resource :home_exposure_response, 
				:only => [ :new, :create, :show ]
			subject.resources :survey_invitations, 
				:only => [:create,:update,:destroy,:show]
			subject.resources :addresses,
				:only => [:new,:create,:edit,:update,:index]
			subject.resources :enrollments,
				:only => [:new,:create,:show,:edit,:update,:index]
		end
#		hx.namespace :subjects do |hxs|
#			hxs.resources :generals, :only => :index
#		end
		hx.resources  :enrolls, :only => [:index],
			:collection => { 
				:send_letters  => :get,
				:update_select => :put }
		hx.resources  :interviews
		hx.resources  :samples, :only => [:index],
			:collection => { 
				:send_kits  => :get }
		hx.resources  :followups
#		hx.resources  :letters, :only => [:index],
#			:collection => {
#				:bulk_create => :post,
#				:bulk_update => :post
#			}
	end

	map.resources :subjects, :shallow => true do |subject|
#		subject.resource :dust_kit
#		subject.resource :home_exposure_response, 
#			:only => [ :new, :create, :show ]
#		subject.resources :survey_invitations, 
#			:only => [:create,:update,:destroy,:show]
	end
#	map.resources :survey_invitations, :only => :show
	map.resource :survey_finished, :only => :show

	map.connect 'stylesheets/:action.:format', :controller => 'stylesheets'
	map.connect 'javascripts/:action.:format', :controller => 'javascripts'

	map.resources :projects

	map.resources :locales, :only => :show


#	map.resources :user_invitations, :only => [:new,:create,:show]




	#	MUST BE LAST OR WILL BLOCK ALL OTHER ROUTES!
	#	catch all route to manage admin created pages.
	map.connect   '*path', :controller => 'pages', :action => 'show'



	# Install the default routes as the lowest priority.
	# Note: These default routes make all actions in every controller accessible via GET requests. You should
	# consider removing or commenting them out if you're using named routes and resources.
#	map.connect ':controller/:action/:id'
#	map.connect ':controller/:action/:id.:format'
end

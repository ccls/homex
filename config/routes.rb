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

	map.logout   '/logout', :controller => 'sessions', :action => 'destroy'

#	map.resources :deputies,  :only => [ :index, :create, :destroy ]

	map.resource  :calendar, :only => [ :show ]
	map.resource  :session, :only => [ :destroy ]
	map.resources :users,  :only => [ :index, :show, :update ]
	map.resources :pages, :collection => { :order => :post }
	# new and create for packages are just for demo development
	map.resources :packages, :only => [ :index, :show, :new, :create, :update ]
	map.resources :permissions, :only => :index
	map.resources :response_sets, :only => [ :create ]
	map.resources :subjects, :only => [ :index, :show ] do |subject|
		subject.resource :home_exposure_questionnaire, :only => [ :new ]
	end




	map.connect 'javascripts/:action.:format', :controller => 'javascripts'


	#	MUST BE LAST
	#	catch all route to manage admin created pages.
	map.connect   '*path', :controller => 'pages', :action => 'show'

	# Install the default routes as the lowest priority.
	# Note: These default routes make all actions in every controller accessible via GET requests. You should
	# consider removing or commenting them out if you're using named routes and resources.
#	map.connect ':controller/:action/:id'
#	map.connect ':controller/:action/:id.:format'
end

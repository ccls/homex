ActionController::Routing::Routes.draw do |map|
	map.resources :guides

	map.resources :people

#	It appears that the plugin routes are loaded after
#	the app's (or they aren't overridable) as this 'root'
#	is not the 'root'.  The 'root' from the engine is.
#	Plugin routes are loaded FIRST and aren't overridable.
	map.root :controller => :home_exposures, :action => :show

	map.resource  :calendar,   :only => [ :show ]

	map.resources :home_page_pics, :collection => { :activate => :post }
	map.resources :packages, :except => :edit, 
		:member => { :ship => :put, :deliver => :put }
	map.resources :response_sets, :only => [ :create ]

	map.resource :home_exposure, :only => :show

	map.resources :subjects,
		:shallow => true do |subject|
		subject.resources :samples do |sample|
			#	one kit per sample
			sample.resources :sample_kits, :except => [:index]
		end
		subject.resource :home_exposure_response, 
			:only => [ :new, :create, :show ]
		subject.resources :survey_invitations, 
			:only => [:create,:update,:destroy,:show]
		subject.resource :patient
		subject.resources :contacts, :only => :index
		subject.resources :phone_numbers,		#	TEMP ADD DESTROY FOR DEV ONLY!
			:only => [:new,:create,:edit,:update,   :destroy   ]
		subject.resources :addressings,		#	TEMP ADD DESTROY FOR DEV ONLY!
			:only => [:new,:create,:edit,:update,   :destroy   ]
		subject.resources :enrollments,
			:only => [:new,:create,:show,:edit,:update,:index]
	end

	map.namespace :interview do |interview|
		interview.resources  :subjects
	end

	#	CANNOT HAVE A NAMESPACE AND A RESOURCE WITH THE SAME NAME
	#	(APPARENTLY)
	map.namespace :sample do |sample|
		sample.resources  :subjects, :only => [:index,:show],
			:collection => { 
				:send_to_lab  => :get }
	end

	map.namespace :followup do |followup|
		followup.resources  :subjects
	end

#	map.resources :survey_invitations, :only => :show
	map.resource :survey_finished, :only => :show

	map.resources :projects
	map.resources :races


	#	MUST BE LAST OR WILL BLOCK ALL OTHER ROUTES!
	#	catch all route to manage admin created pages.
	map.connect   '*path', :controller => 'pages', :action => 'show'

end

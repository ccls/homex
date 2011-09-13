ActionController::Routing::Routes.draw do |map|
#	It appears that the plugin routes are loaded after
#	the app's (or they aren't overridable) as this 'root'
#	is not the 'root'.  The 'root' from the engine is.
#	Plugin routes are loaded FIRST and aren't overridable.
	map.root :controller => :home_exposures, :action => :show

#	map.resource  :calendar,   :only => [ :show ]

	map.resources :home_page_pics, :collection => { :activate => :post }
	map.resources :packages, :except => :edit, 
		:member => { :ship => :put, :deliver => :put }

	map.resource :home_exposure, :only => :show

	map.resources :study_subjects,
		:shallow => true do |study_subject|

		study_subject.resources :samples do |sample|
			#	one kit per sample
			sample.resources :sample_kits, :except => [:index]
		end
		study_subject.resource :home_exposure_response, 
			:only => [ :show ] 
#			:only => [ :new, :create, :show, 
#			:destroy ]	# TEMP ADD DESTROY FOR DEV ONLY!
		study_subject.resource :patient
		study_subject.resources :contacts, :only => :index
		study_subject.resources :phone_numbers,		#	TEMP ADD DESTROY FOR DEV ONLY!
			:only => [:new,:create,:edit,:update,   :destroy   ]
		study_subject.resources :addressings,		#	TEMP ADD DESTROY FOR DEV ONLY!
			:only => [:new,:create,:edit,:update,   :destroy   ]
		study_subject.resources :enrollments,
			:only => [:new,:create,:show,:edit,:update,:index]
		study_subject.resources :interviews,
			:only => [:show,:edit,:update,:destroy]
		study_subject.resources :events,
			:only => [:index]
	end

	map.namespace :interview do |interview|
		interview.resources  :study_subjects
	end

	#	CANNOT HAVE A NAMESPACE AND A RESOURCE WITH THE SAME NAME
	#	(APPARENTLY)
	map.namespace :sample do |sample|
		sample.resources  :study_subjects, :only => [:index,:show],
			:collection => { 
				:send_to_lab  => :get }
	end

	map.namespace :followup do |followup|
		followup.resources :study_subjects
		followup.resources :gift_cards
	end

	map.resources :projects
#	map.resources :races
#	map.resources :languages
	map.resources :guides
#	map.resources :people
	map.resources :gift_cards
#	map.resources :refusal_reasons
#	map.resources :ineligible_reasons
	map.resources :document_versions

	map.namespace :api do |api|
		api.resources :study_subjects, :only => :show	#[:show,:index]
	end

	#	Create named routes for expected pages so can avoid
	# needing to append the relative_url_root prefix manually.
	#	ActionController::Base.relative_url_root + '/admin',
	map.with_options :controller => "pages", :action => "show" do |page|
		page.admin   '/admin',   :path => ["admin"]
		page.faqs    '/faqs',    :path => ["faqs"]
		page.reports '/reports', :path => ["reports"]
	end
	#	MUST BE LAST OR WILL BLOCK ALL OTHER ROUTES!
	#	catch all route to manage admin created pages.
	map.connect   '*path', :controller => 'pages', :action => 'show'

end

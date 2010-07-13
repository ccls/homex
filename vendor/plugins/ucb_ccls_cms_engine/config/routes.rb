ActionController::Routing::Routes.draw do |map|
	map.root :controller => "pages", :action => "show", :path => [""]
	map.resources :pages, :collection => { :order => :post }

	map.connect 'stylesheets/:action.:format', :controller => 'stylesheets'
	map.connect 'javascripts/:action.:format', :controller => 'javascripts'

	map.resources :locales, :only => :show

end

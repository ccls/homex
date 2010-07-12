ActionController::Routing::Routes.draw do |map|
	map.root :controller => "pages", :action => "show", :path => [""]
	map.resources :pages, :collection => { :order => :post }
end

class PageSweeper < ActionController::Caching::Sweeper
	observe Page

#	While sweepers are model observers, they only seem
#	to be so within the scope of a given controller.
#	If the 'cache_sweeper' line is not given in the 
#	controller, these observers don't see it.
#	In addition, saving or destroying a page outside
#	of the scope of the controller (ie. from console)
#	will also go unnoticed.

	def after_save(page)
		expire_cache(page)
	end

	def after_destroy(page)
		expire_cache(page)
	end

	def expire_cache(page)
		#	Please note that the "views/" prefix is
		#	internal to rails.  Don't meddle with it.

		#	Expired fragment: views/page_menu (0.0ms)
		expire_fragment 'page_menu'

		#	We don't really access the pages via :id
		#		but they can be so we need to deal with the cache.
		#	Expired fragment: views/dev.sph.berkeley.edu:3000/pages/1 (0.0ms)
		#	Expired fragment: views/dev.sph.berkeley.edu:3000/pages/5 (0.0ms)
		expire_action

		#	Expired fragment: views/dev.sph.berkeley.edu:3000/alpha (0.0ms)
		#	Expired fragment: views/dev.sph.berkeley.edu:3000/ (0.0ms)
		#	This fails for the home page as "/" is 
		#		called "index" by the server
		#	NEEDS to change page.path to /index for home page
		#		be views/dev.sph.berkeley.edu:3000/index !
		page_path = ( page.path == "/" ) ? "/index" : page.path
		expire_fragment "#{request.host_with_port}#{page_path}"

	end

end

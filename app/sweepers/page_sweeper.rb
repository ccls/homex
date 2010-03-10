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
		expire_fragment 'page_menu'
#	this won't expire the home page, because it is confused
#	as to whether it is a show or index
#	views/dev.sph.berkeley.edu:3000/alpha
#	views/dev.sph.berkeley.edu:3000/index  <--- ???
#	alpha will expire, but not index
#		expire_action( :action => [:show, :index] )
#	actually neither do.
#	maybe 
#		expire_action page.path
#	or something (in addition to ...)
		expire_action
	end

end

jQuery(function(){
	jQuery('#pages').sortable({
		axis:'y', 
		dropOnEmpty:false, 
		handle:'img.handle', 
		items:'div.page.row'
	});
	before = jQuery('#pages').sortable('serialize',{key:'pages[]'})

	jQuery('form#order_pages').submit(function(){
		after = jQuery('#pages').sortable('serialize',{key:'pages[]'})
		if( before == after ) {
			alert("Page order hasn't changed");
			return false
		}
	})

});

var initial_page_order;
jQuery(function(){
	jQuery('#pages').sortable({
		axis:'y', 
		dropOnEmpty:false, 
		handle:'img.handle', 
		update:function(event,ui){compare_page_order()},
		items:'div.page.row'
	});

	jQuery('#save_order').disable();

	initial_page_order = page_order();

	jQuery('form#order_pages').submit(function(){
		if( initial_page_order == page_order() ) {
			/*
				Should get here as button should 
				be disable if not different!
			*/
			alert("Page order hasn't changed. Nothing to save.");
			return false
		}
	})

});

function page_order() {
	return jQuery('#pages').sortable('serialize',{key:'pages[]'});
}

function compare_page_order(){
	if( initial_page_order == page_order() ) {
		jQuery('#save_order').disable();
	} else {
		jQuery('#save_order').enable();
	}
}

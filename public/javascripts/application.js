jQuery(function(){

	jQuery('button.link').click(function(){
		window.location.href = $(this).find('span.href').text();
	});

	jQuery('p.flash').click(function(){$(this).remove();});

	var root = (location.host == 'ccls.berkeley.edu')?'/homex':''
	jQuery.getScript(root + 
		'/javascripts/cache_helper.js?caller=' +
		location.pathname.replace(new RegExp('^' + root),'') );

});

jQuery(function(){

	jQuery('button.link').click(function(){
		window.location.href = $(this).find('span.href').text();
	});

	jQuery('p.flash').click(function(){$(this).remove();});

	jQuery.getScript('/javascripts/cache_helper.js');
	jQuery.getScript('/homex/javascripts/cache_helper.js');

});

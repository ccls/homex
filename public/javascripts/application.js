jQuery(function(){

	jQuery('button.link').click(function(){
		window.location.href = $(this).find('span.href').text();
	});

	jQuery('p.flash').click(function(){$(this).remove();});

	var root = (location.host == 'ccls.berkeley.edu')?'/homex':''
	jQuery.getScript(root + 
		'/javascripts/cache_helper.js?caller=' +
		location.pathname.replace(new RegExp('^' + root),'') );

	var _gaq = _gaq || [];
	_gaq.push(['_setAccount', 'UA-17648061-8']);
	_gaq.push(['_trackPageview']);

	var ga = document.createElement('script'); 
	ga.type = 'text/javascript'; 
	ga.async = true;
	ga.src = ('https:' == document.location.protocol ? 
		'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
	var s = document.getElementsByTagName('script')[0]; 
	s.parentNode.insertBefore(ga, s);

});

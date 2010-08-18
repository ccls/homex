jQuery(function(){

	jQuery('a.submitter').click(function(){
		form_id = this.id.replace(/^for_/,'')
		jQuery('form#'+form_id).submit();
		return false;
	});

	jQuery('button.link').click(function(){
		window.location.href = $(this).find('span.href').text();
	});

	jQuery('p.flash').click(function(){$(this).remove();});

	var root = (location.host == 'ccls.berkeley.edu')?'/homex':''
	jQuery.getScript(root + '/pages/translate.js');
/*
		'/javascripts/cache_helper.js?caller=' +
		location.pathname.replace(new RegExp('^' + root),'') );
*/

});

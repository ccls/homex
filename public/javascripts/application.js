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

/*	Pointless as nothing is translatable on homex
	
	var root = (location.host == 'ccls.berkeley.edu')?'/homex':''
	jQuery.getScript(root + '/pages/translate.js');
*/

/*	Old

		'/javascripts/cache_helper.js?caller=' +
		location.pathname.replace(new RegExp('^' + root),'') );
*/

});

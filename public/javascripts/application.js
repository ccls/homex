jQuery(function(){

	jQuery('a.submitter').click(submit_form);

	jQuery('form.confirm').submit(confirm_submission);

	jQuery('button.link').click(function(){
		window.location.href = $(this).find('span.href').text();
	});

	jQuery('p.flash').click(function(){$(this).remove();});

	jQuery('.datepicker').datepicker();

	jQuery('a.ajax').click(function(){
//		jQuery.getScript($(this).attr('href')+'.js');
		jQuery.get($(this).attr('href')+'.js', function(data){
			jQuery('#ajax').html(data);
		});
		return false;
	});


	/* jquery ui testing */
/*
	jQuery("#mainmenu a").addClass('ui-state-default ui-corner-top');
	jQuery("#mainmenu a.current").addClass('ui-state-active');
	jQuery("#submenu").addClass('ui-state-active');
	jQuery("#id_bar").addClass('ui-state-active');
	jQuery("#id_bar .controls a").addClass('ui-state-default ui-corner-all');
	jQuery(".ui-state-default").mouseover(function(){
		$(this).addClass('ui-state-hover');
	}).mouseout(function(){
		$(this).removeClass('ui-state-hover');
	});
*/
});

var submit_form = function() {
	form_id = this.id.replace(/^for_/,'');
	jQuery('form#'+form_id).submit();
	return false;
}

var confirm_submission = function(){
	if( !confirm("Please confirm that you want to save all changes. Otherwise, press 'cancel' and navigate to another page without saving.") ){
		return false;
	}
}

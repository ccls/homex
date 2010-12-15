jQuery(function(){

	jQuery('.valid .is_valid #addressing_is_valid').change(function(){
		toggle_why_invalid( ( $(this).val()!=2 && $(this).val()!=999 ) );
	});

	jQuery('.verified .is_verified #addressing_is_verified').change(function(){
		toggle_how_verified($(this).attr('checked'));
	});

});
/*
	These functions have the same name for editing a phone number
	and an addressing so if there is ever a form with both,
	be aware, BE VERY AWARE!
*/
toggle_why_invalid = function(checked) {
	/* This SHOULD be REVERSED */
	if( checked ){
		$('.why_invalid.field_wrapper').hide()
	} else {
		$('.why_invalid.field_wrapper').show()
	}
}

toggle_how_verified = function(checked) {
	if( checked ){
		$('.how_verified.field_wrapper').show()
	} else {
		$('.how_verified.field_wrapper').hide()
	}
}

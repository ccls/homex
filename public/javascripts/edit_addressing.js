jQuery(function(){

	jQuery('.valid .is_valid #addressing_is_valid').change(function(){
		toggle_why_invalid($(this).attr('checked'));
	});

	jQuery('.verified .is_verified #addressing_is_verified').change(function(){
		toggle_how_verified($(this).attr('checked'));
	});

});

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

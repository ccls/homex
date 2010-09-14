jQuery(function(){

	jQuery('form#new_addressing').submit(state_check);

});

var state_check = function() {
	if( ( jQuery('#addressing_address_attributes_state').val() != 'CA' ) &&
		( !confirm('This address is not in CA and will make subject ineligible.  Do you want to continue?') ) ) {
		return false;
	}
}


jQuery.noConflict();

// JavaScript Document
jQuery(document).ready(function() {
	jQuery('#form-login').slidinglabels({
		className    : 'form-slider', // the class you're wrapping the label & input with -> default = slider
		topPosition  : '5px',  // how far down you want each label to start
		leftPosition : '5px',  // how far left you want each label to start
		axis         : 'x',    // can take 'x' or 'y' for slide direction
		speed        : 'fast'  // can take 'fast', 'slow', or a numeric value
	});
        jQuery('.label-slide').slidinglabels({
		className    : 'text', // the class you're wrapping the label & input with -> default = slider
		topPosition  : '5px',  // how far down you want each label to start
		leftPosition : '5px',  // how far left you want each label to start
		axis         : 'x',    // can take 'x' or 'y' for slide direction
		speed        : 'fast'  // can take 'fast', 'slow', or a numeric value
	});
        jQuery('.label-slide').slidinglabels({
		className    : 'password', // the class you're wrapping the label & input with -> default = slider
		topPosition  : '5px',  // how far down you want each label to start
		leftPosition : '5px',  // how far left you want each label to start
		axis         : 'x',    // can take 'x' or 'y' for slide direction
		speed        : 'fast'  // can take 'fast', 'slow', or a numeric value
	});
});

(function($){
  $(function(){
    if(typeof MEIO_MASK != "undefined") $('input:text').setMask();
  }
);
})(jQuery);


function Loading(select_id)
{
    jQuery('select#' + select_id).html('<option>Carregando...</option>');
}
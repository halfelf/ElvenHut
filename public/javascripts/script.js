	
    	$(document).ready (
    		function(){
/*	    		var path = document.location.href ? document.location.href : document.location;	
	    		$('#nav li a').each(function() {
        if( path === this.href ){
            $(this).addClass('active');
        }
    });*/
    
    
    	$('#nav li a').hover(
	function() {
	
if (this.className == ""){
    	$(this).stop().animate({ 'padding-top' : 90, 'padding-bottom' : 10 }, 300).css({ background: '#fa453c'});
    	}else
    	{
	    	$(this).css({ background: '#fa453c'});
    	}
    },
    function() {
    
if (this.className == "")
{
    	$(this).stop().animate({ 'padding-top' : 60, 'padding-bottom' : 4 }, 300).css({ background: '#4b5258'});
    	}
    	else
    	{
	    	$(this).css({ background: '#4b5258'});
    	}
    }
);
		});
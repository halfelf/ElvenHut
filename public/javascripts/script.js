$(document).ready (
    function(){
      $('#nav li a').hover(
        function() {
          if (this.className == ""){
            $(this).stop().animate({ 'padding-top' : 90, 'padding-bottom' : 10 }, 300).css({ background: '#fa453c'});
          }
          else{
            $(this).css({ background: '#fa453c'});
          }
        },
        function() {
          if (this.className == ""){
            $(this).stop().animate({ 'padding-top' : 60, 'padding-bottom' : 4 }, 300).css({ background: '#4b5258'});
          }
          else{
            $(this).css({ background: '#4b5258'});
          }
        }
      );
    });

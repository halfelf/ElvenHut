function showHide(shID) {
  if (document.getElementById(shID)) {
//    if (document.getElementById(shID+'-show').style.display != 'none') {
      document.getElementById(shID).style.display = 'block';
//    }
//    else {
 //     document.getElementById(shID+'-show').style.display = 'inline';
 //     document.getElementById(shID).style.display = 'none';
      //document.getElementById(shID).style.opacity = '0';
//    }
  }
}
function hideHide(shID) {
  if (document.getElementById(shID)) {
    document.getElementById(shID).style.display = 'none';
  }
}

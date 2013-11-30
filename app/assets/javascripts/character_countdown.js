function updateCountdown() {
  // 140 characters max
  var left = 140 - jQuery('#micropost_content').val().length;
  if(left == 1) {
    var charactersLeft = ' character left.'
  }
  else if (left == -1){
    var charactersLeft = ' character too many.'
  }
  else if(left < -1){
    var charactersLeft = ' characters too many.'
  }
  else{
    var charactersLeft = ' characters left.'
  }
  jQuery('.countdown').text(Math.abs(left) + charactersLeft);
}

jQuery(document).ready(function($) {
  updateCountdown();
  $('#micropost_content').change(updateCountdown);
  $('#micropost_content').keyup(updateCountdown);
});
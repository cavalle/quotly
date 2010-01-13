$(document).ready(function(){
  $(".quote").hover(function(){
    $(this).find(".actions").fadeIn();
  }, function(){
    $(this).find(".actions").fadeOut();
  })
})
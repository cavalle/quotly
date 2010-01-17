$(document).ready(function(){
  $(".quote").hover(function(){
    $(this).find(".actions").fadeIn();
  }, function(){
    $(this).find(".actions").fadeOut();
  });
  $("#openid_identifier").focus(function(){
    $(this).addClass("selected");
  });
  $("#openid_identifier").blur(function(){
    if ($(this).val() == "") $(this).removeClass("selected");
  })
})
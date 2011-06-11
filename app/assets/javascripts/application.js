// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.8.custom.min
//= require_self
//= require_tree .

$(document).ready(function(){
  $(".quote").hover(function(){
    $(this).find(".actions").fadeIn();
  }, function(){
    $(this).find(".actions").fadeOut();
  });

  $("input#author").autocomplete({
    source: function(request, response) {
      $.ajax({
        url: "/authors",
        method: "GET",
        data: { q: request.term },
        success: function(data) {
          response(eval(data));
        }
      });
    }
  });

  $("input#source").autocomplete({
    source: function(request, response) {
      $.ajax({
        url: "/sources",
        method: "GET",
        data: { q: request.term },
        success: function(data) {
          response(eval(data));
        }
      });
    }
  });
})

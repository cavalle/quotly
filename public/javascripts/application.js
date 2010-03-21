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
$(document).ready(function() {
  var width = $(window).width(),
      smallWidth = 600;

  if (width <= smallWidth) {
    $('.js-start-hidden').hide();
  }

  $('.js-collapse').on('click', function() {
    $(this).next().toggle();
  });


/*
  var token = '4fac62463f61b05dcf000088';
  $.getJSON('http://tapirgo.com/api/1/search.json?token=' + token + '&query=' + paramValue('query') + '&callback=?', function(data){
    var target = $('#posts');
    target.html('');
    $.each(data, function(key, val) {
      target.append(
        '<article>' +
        '<a class="date clearfix" href="' + val.link + '">' + val.published_on + '</a>' +
        '<h1 class="js-collapse">' + val.title + '</h1>' +
        '<div>' +  val.content + '</div></article>'
      );
    });
  });

  // Extract the param value from the URL.
  function paramValue(query_param) {
    var results = new RegExp('[\\?&]' + query_param + '=([^&#]*)').exec(window.location.href);
    return results ? results[1] : false;
  }
*/
});

$(document).ready(function() {
  var width = $(window).width(),
      smallWidth = 600;

  if (width <= smallWidth) {
    $('.js-start-hidden').hide();
  }

  $('.js-collapse').on('click', function() {
    $(this).next().toggle();
  });
});

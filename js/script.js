$(document).ready(function() {
  $('.js-collapse').on('click', function() {
    console.log('click');
    $(this).next().collapse('toggle');
  });
});

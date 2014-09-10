grinfit = typeof(grinfit) != "undefined" ? grinfit : {};
grinfit.lastSearchTerm = '';

$(function() {
  var width = $(window).width(),
      smallWidth = 600;

  if (width <= smallWidth && $('.js-start-hidden').length > 1) {
    $('.js-start-hidden').hide();
  }

  $('#container').on('click', '.js-collapse', function() {
    $(this).closest('article').find('.content').toggle();
  });


  $('#search').focus(function() {
    $(this).addClass('js-focused').next('.clear-icon').fadeIn(750);
  });

  $('.clear-icon').click(function(){
    $(this).prev('input').val('').focus().trigger('do-search');
  });


  // This script fixes the shift that occurs in a centered layout when the page grows and forces scrollbars to appear.
  // http://www.aaubry.net/fixing-jumping-content-when-scrollbars-appear.aspx
  /*
  var body = $("body"),
      previousWidth = null;

  var resizeBody = function () {
    var currentWidth = body.width();

    if (currentWidth != previousWidth) {
      previousWidth = currentWidth;
      // Measure the scrollbar size
      body.css("overflow", "hidden");
      var scrollBarWidth = body.width() - currentWidth;
      body.css("overflow", "auto");
      body.css("margin-left", scrollBarWidth + "px");
    }
  };

  // setInterval is required because the resize event is not fired when a scrollbar appears or disappears.
  setInterval(resizeBody, 30);
  resizeBody();
  */

  doSearch = function(searchTerm) {
    //$('#search-progress').show();
    if (!grinfit.searchCache) {
      setTimeout(doSearch,200);
    }

    var term = $.trim(searchTerm.toLowerCase()),
        regex = new RegExp(term, 'im'),
        results = [],
        i = 0,
        resultsDiv = $('#search-results');

    if (term) {
      if (term != grinfit.lastSearchTerm) {
        grinfit.lastSearchTerm = term;
        for (i in grinfit.searchCache) {
          var post = grinfit.searchCache[i];
          if (regex.test(post.title) || regex.test(post.contentClean)) {
            results.push(post);
          }
        }

        $('.js-hide-on-search').hide();
        $('.js-invis-on-search').css('visibility', 'hidden');
        resultsDiv.html('').show();
        if (results.length) {
          last = results.length - 1;
          for (i in results) {
            resultsDiv.append(results[i].content);
          }
          resultsDiv.find('.js-start-hidden').hide();
        }
        else {
          resultsDiv.append('<div id="no-results">No results.</div>');
        }
      }
    }
    else {
      resultsDiv.hide();
      $('.js-hide-on-search').show();
      $('.js-invis-on-search').css('visibility', 'visible');
    }
    //$('#search-progress').hide();
  };

  $('#search').on('keyup do-search', function() {
    clearTimeout(grinfit.searchTimer);
    var val = $(this).val();
    grinfit.searchTimer = setTimeout(function() {
      doSearch(val);
    }, 200);
  });

  $.get('/search.json', function(data) {
    data.pop(); // remove the false at the end of the array
    grinfit.searchCache = data;
  });
});


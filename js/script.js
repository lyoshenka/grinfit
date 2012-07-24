grinfit = typeof(grinfit) != "undefined" ? grinfit : {};
grinfit.lastSearchTerm = '';

$(document).ready(function() {
  var width = $(window).width(),
      smallWidth = 600;

  if (width <= smallWidth) {
    $('.js-start-hidden').hide();
  }

  $('#container').on('click', '.js-collapse', function() {
    $(this).closest('article').find('.content').toggle();
  });


  doSearch = function(searchTerm) {
    $('#search-progress').show();
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
            resultsDiv.append(results[i].content + (i < last ? '<hr/>' : ''));
          }
          resultsDiv.find('.js-start-hidden').hide();
        }
        else {
          resultsDiv.append('<div id="no-results">No results.</div>');
          console.log('no results');
        }
      }
    }
    else {
      resultsDiv.hide();
      $('.js-hide-on-search').show();
      $('.js-invis-on-search').css('visibility', 'visible');
    }
    $('#search-progress').hide();
  };

  $('#search').keyup(function() {
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

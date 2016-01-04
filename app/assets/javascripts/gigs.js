$(function() {
    $(".gigs--posters").swipe( {
        //Generic swipe handler for all directions
        swipe:function(event, direction, distance, duration, fingerCount, fingerData) {
            if (direction == "up") {
                var topPoster = $('.top');
                if (topPoster.prev().first().hasClass('posters--event')) {
                    topPoster.addClass('hide');
                    topPoster.prev().first().addClass('top');
                    topPoster.removeClass('top');
                }
            } else if (direction == "down") {
                var topPoster = $('.top')
                if (topPoster.next().first().hasClass('posters--event')) {
                    topPoster.next().first().removeClass('hide');
                    topPoster.next().first().addClass('top');
                    topPoster.removeClass('top');
                }
            }
        }
    });
});
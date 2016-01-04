$(function() {
    $(".gigs--posters").swipe( {
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
    
    var mousewheelStopped = true;
    
    $(document).bind('mousewheel', function(evt) {
        var delta = evt.originalEvent.wheelDelta;
        
        if (delta == 0) {
            mousewheelStopped = true;
        }
        
        setTimeout(function(){
            if (delta > 10 && mousewheelStopped == true) {
                var topPoster = $('.top')
                if (topPoster.next().first().hasClass('posters--event')) {
                    topPoster.next().first().removeClass('hide');
                    topPoster.next().first().addClass('top');
                    topPoster.removeClass('top');
                }
                mousewheelStopped = false;
            } else if (delta < -10 && mousewheelStopped == true) {
                var topPoster = $('.top');
                if (topPoster.prev().first().hasClass('posters--event')) {
                    topPoster.addClass('hide');
                    topPoster.prev().first().addClass('top');
                    topPoster.removeClass('top');
                }
                mousewheelStopped = false;
            }
        }, 100);
    })
});
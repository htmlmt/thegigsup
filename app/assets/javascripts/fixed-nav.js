Element.prototype.addClass = function(className) {
    if(this.hasClass(className) == false) {
        this.className += ' ' + className;
    }

}

Element.prototype.removeClass = function(className) {
    if(this.hasClass(className)) {
        var rx = new RegExp('(\\s|^)' + className + '(\\s|$)', 'g');
        this.className = this.className.replace(rx, ' ');
    }
}

Element.prototype.hasClass = function(className) {
    var rx = new RegExp('(\\s|^)' + className + '(\\s|$)');

    if(this.className.match(rx)) {
        return true;
    }

    return false;
}

// Fires after all load events are complete
window.onload = setupDom;

// Fires when viewport resized
window.onresize = resizeDom;

// Fires when scroll
window.onscroll = doOnScroll;

$(window).on('page:load', setupDom);

function setupDom() {
    // Get all elements that need animation
    var elements = document.querySelectorAll('.events--navigation'),
    // This is a holder for each element object.
        element = {};

    // Loop through NodeList elements and add each element to an object, figure out how far from top of document
    // and add to elements array
    for(var i = 0, len = elements.length; i < len; i++) {
        element = {
            element: elements[i],
            top: getDistanceFromTop(elements[i])
        }
        animations.elements.push(element);
    }

    // Run doOnScroll once in case some elements are in viewport onload
    setTimeout(function() { doOnScroll(); }, 10);
}

function resizeDom() {
    // Refigure offsets when window is resized
    animations.elements.forEach(function(element, index, array) {
        element.top = getDistanceFromTop(element.element);
    });
}

// **********************************************
// Move progress bars based on scroll
// **********************************************
function doOnScroll() {
    animations.testScroll();
}

var animations = {
    iconOffset: 0,
    elements: [],
    testScroll: function () {
        // Determine how far the user has scrolled
        var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;

        // Loop through array of elements and test each one to see if it's within viewport
        // If so, animate
        this.elements.forEach(function(element, index, array) {
            if ($('.body--header').outerHeight() < scrollTop) {
                if (element.element.hasClass('fixed') == false) {
                    element.element.addClass('fixed');
                    $('.events--month').addClass('fixed');
                }
            } else {
                if (element.element.hasClass('fixed')) {
                    element.element.removeClass('fixed');
                    $('.events--month').removeClass('fixed');
                }
            }
        });
    }
};

//Loops through all parent nodes of an element to get it's distance from the top of the document
function getDistanceFromTop(element) {
    var yPos = 0;

    while(element) {
        yPos += (element.offsetTop);
        element = element.offsetParent;
    }

    return yPos;
}
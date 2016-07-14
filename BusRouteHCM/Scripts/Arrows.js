function ArrowHandler() {
    this.setMap(map);
    // MapCanvasProjection is only available after draw has been called.
    //  this.draw = function() {};
    // Markers with 'head' arrows must be stored
    this.arrowheads = [];
}

ArrowHandler.prototype = new google.maps.OverlayView();

// Draw is inter alia called on zoom change events.
// So we can use the draw method as zoom change listener
ArrowHandler.prototype.draw = function () {

    if (arrows) {
        for (i in arrows) {
            arrows[i].setMap(null);
        }

        // Now, clear the array itself.
        arrows = [];
    }

    var zoom0 = 10;
    var nowZoom = map.getZoom(); //zoom in thi zoom tang
    var numArrows = (nowZoom - zoom0) * 2;
    var freq = Math.round(this.arrowheads.length / numArrows);
    if(freq==0) freq=1;
    if (numArrows > 0)
        if (this.arrowheads.length > 0) {
            for (var i = 0; i < this.arrowheads.length - 1; i += freq) {

                var p1 = this.arrowheads[i];
                var p2 = this.arrowheads[i + 1];
                this.create(p1, p2);

            }
        }
};


// Returns the triangle icon object
ArrowHandler.prototype.addIcon = function (file) {
    var g = google.maps;
    var folder = "http://www.google.com/mapfiles/";
    folder = "./images/arrows/";
    var icon = new g.MarkerImage(folder + file,
    new g.Size(24, 24), null, new g.Point(12, 12));
    return icon;
};

// Creates markers with corresponding triangle icons
ArrowHandler.prototype.create = function (p1, p2) {
    var g = google.maps;
    var markerpos = g.geometry.spherical.interpolate(p1, p2, .5);

    // Compute the bearing of the line in degrees
    var dir = g.geometry.spherical.computeHeading(p1, p2).toFixed(1);
    // round it to a multiple of 3 and correct unusable numbers
    dir = Math.round(dir / 3) * 3;
    //    if (dir < 0) dir += 240;
    //    if (dir > 117) dir -= 120;
    if (dir < 0) dir += 360;
    // use the corresponding icon
    //var icon = this.addIcon("dir_" + dir + ".png"); //google dir
    var icon = this.addIcon("arrow_" + dir + ".png");
    var marker = new g.Marker({ position: markerpos,
        map: map, icon: icon
        //title: '( ' + p1.lat() + ' - ' + p1.lng() + ')' + ' -> ' + '( ' + p2.lat() + ' - ' + p2.lng() + ')'
    });

    arrows.push(marker);

};

ArrowHandler.prototype.load = function (points) {
    this.arrowheads = points;
};


// Draws a polyline with accordant arrow heads
function createPoly(path, mode) {
    var poly = new google.maps.Polyline({
        strokeColor: "#0000ff",
        strokeOpacity: 0.8,
        strokeWeight: 3,
        map: map,
        path: path
    });

    setArrows.load(path);
    return poly;
}
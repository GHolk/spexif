// Generated by CoffeeScript 1.12.1
(function() {
  var GoogleMap, myMap;

  GoogleMap = (function() {
    function GoogleMap() {}

    GoogleMap.prototype.initMap = function() {
      var latLng, mapOptions;
      latLng = {
        lat: 23.652186,
        lng: 120.978075
      };
      mapOptions = {
        center: latLng,
        zoom: 8,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      return this.googleMap = new google.maps.Map(document.getElementById('google-map-container'), mapOptions);
    };

    GoogleMap.prototype.createPoint = function(image) {
      var latLng;
      latLng = {
        lng: image.exif.gps[0],
        lat: image.exif.gps[1]
      };
      return new google.maps.InfoWindow({
        content: image.toHTMLNode(),
        position: latLng
      });
    };

    GoogleMap.prototype.showPoint = function(image) {
      return image.mapPoint.open(this.googleMap);
    };

    GoogleMap.prototype.removePoint = function(image) {
      var ref;
      return (ref = image.mapPoint) != null ? ref.close() : void 0;
    };

    return GoogleMap;

  })();

  myMap = new GoogleMap();

  google.maps.event.addDomListener(window, 'load', myMap.initMap.bind(myMap));

  spexif.myMap = myMap;

}).call(this);

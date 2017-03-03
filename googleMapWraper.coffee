
class GoogleMap
    initMap: ->
        latLng = 
            lat: 23.652186
            lng: 120.978075

        mapOptions =
            center: latLng
            zoom: 8
            mapTypeId: google.maps.MapTypeId.ROADMAP

        @googleMap = new google.maps.Map(
            document.getElementById('google-map-container'),
            mapOptions
        )

    createPoint: (image) ->
        latLng = 
            lng: image.exif.gps[0]
            lat: image.exif.gps[1]

        new google.maps.InfoWindow {
            content: image.toHTMLNode()
            position: latLng
        }

    showPoint: (image) ->
        image.mapPoint.open @googleMap

myMap = new GoogleMap()
google.maps.event.addDomListener window, 'load', myMap.initMap.bind myMap
spexif.myMap = myMap



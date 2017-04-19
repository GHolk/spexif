
# leaflet map use [latitude, longitude] format, odd.

class LeafletMap
    reverseLntLat = (lngLat) -> [lngLat[1], lngLat[0]]
    constructor: ->
        map = L.map 'leaflet-map-container', {
            closePopupOnClick: false
        }
        osmLayer = new L.TileLayer(
            'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
            { attribution: """
                Map data © <a href="http://openstreetmap.org">
                OpenStreetMap</a>
                contributors'
            """ }
        )

        map.setView (new L.LatLng 23.652186, 120.978075), 7
        map.addLayer osmLayer
        @map = map

    createPoint: (image) ->
        # leaflet use [lat,lng], so reverse the array.
        marker = L.marker reverseLntLat image.exif.gps
        marker.bindPopup image.toHTMLNode(), {
            autoClose: false
        }
        return marker

    showPoint: (image) ->
        image.mapPoint
            .addTo @map
            .openPopup()

    movePoint: (image, lngLatArray) ->
        image.mapPoint.setLatLng reverseLntLat lngLatArray

    removePoint: (image) ->
        image.mapPoint.remove() if image.mapPoint

myMap = new LeafletMap()
spexif.myMap = myMap



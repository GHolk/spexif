
# leaflet map use [latitude, longitude] format, odd.

class LeafletMap
    reverseLngLat = (lngLat) -> [lngLat[1], lngLat[0]]
    reverseLatLng = (latLng) -> [latLng[1], latLng[0]]
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
        marker = L.marker (reverseLngLat image.exif.gps), {
            draggable: true
            riseOnHover: true
        }
        marker.bindPopup image.HTMLNode, {
            autoClose: false
        }
        marker.on 'dragend', (distance) ->
            latLng = this.getLatLng()
            image.exif.gps = [latLng.lng, latLng.lat]
            image.exif.update()
            image.updateHTMLNode()
            this.setPopupContent image.HTMLNode
            this.openPopup()

        return marker

    showPoint: (image) ->
        image.mapPoint
            .addTo @map
            .openPopup()

    movePoint: (image, lngLatArray) ->
        image.mapPoint.setLatLng reverseLngLat lngLatArray

    removePoint: (image) ->
        image.mapPoint.remove() if image.mapPoint

    updateInfoWindow: (image) ->
        image.mapPoint.setPopupContent image.HTMLNode

myMap = new LeafletMap()
spexif.myMap = myMap



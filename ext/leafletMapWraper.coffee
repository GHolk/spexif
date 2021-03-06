
# leaflet map use [latitude, longitude] format, odd.

class LeafletMap
    reverseLngLat = (lngLat) -> [lngLat[1], lngLat[0]]
    reverseLatLng = (latLng) -> [latLng[1], latLng[0]]
    constructor: ->
        map = L.map 'leaflet-map-container', {
            closePopupOnClick: false
        }
        osmLayer = new L.TileLayer(
            '//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
            { attribution: """
                Map data © <a href="//openstreetmap.org">
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

    distanceBetweenPoint: (gps1, gps2) ->
        if typeof gps2.getLatLng == 'function'
            gps2 = gps2.getLatLng()
        @map.distance gps1, gps2

    drawCircle: (callback) ->
        @map.once 'click', (evt) =>
            circle = L.circle evt.latlng
            circle.addTo @map

            whenMove = (evt) =>
                radius =
                    @distanceBetweenPoint circle.getLatLng(), evt.latlng
                circle.setRadius radius

            @map.on 'mousemove', whenMove
            @map.once 'click', (evt) =>
                @map.off 'mousemove', whenMove
                whenMove evt
                latlng = circle.getLatLng()
                gps = [latlng.lng, latlng.lat]
                radius = circle.getRadius()

                setTimeout ( -> circle.remove()), 10000
                callback gps, radius

myMap = new LeafletMap()
spexif.myMap = myMap




myMap = spexif.myMap

class ImageList extends Array
    constructor: ->
        @map = myMap
        @asideNode = document.getElementById 'image-container'

    add: (image) ->
        @push image
        if image.exif.gps
            @show image
        else
            @showAside image

    show: (image) ->
        @map.showPoint image

    showAside: (image) ->
        @asideNode.appendChild image.toHTMLNode()

spexif.imageList = new ImageList()


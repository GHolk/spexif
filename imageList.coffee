
myMap = spexif.myMap
CacheImage = spexif.CacheImage

class ImageList extends Array
    constructor: ->
        @map = myMap
        @asideNode = document.getElementById 'image-container'

    add: (dataURL) ->
        image = new CacheImage dataURL
        @push image
        if image.exif.gps
            @show image
        else
            @showAside image

    show: (image) ->
        @map.showPoint image

    showAside: (image) ->
        @asideNode.appendChild image.toHTMLNode()

    arraybufferToBinaryString = (arraybuffer) ->
        u8 = new Uint8Array arraybuffer
        charCodeToChar = String.fromCharCode
        (charCodeToChar charCode for charCode in u8).join ''

    addFromURL: (url) ->
        request = new XMLHttpRequest()
        request.open 'GET', url, true
        request.responseType = 'arraybuffer'
        request.onreadystatechange = =>
            req = request
            if req.readyState == 4 && req.status == 200
                @add(
                    'data:image/jpeg;base64,' +
                    btoa arraybufferToBinaryString req.response
                )
        request.send ''

spexif.imageList = new ImageList()


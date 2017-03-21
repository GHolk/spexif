
myMap = spexif.myMap
CacheImage = spexif.CacheImage
getSelectedImages = spexif.domHelper.getSelectedImages

class ImageList
    constructor: ->
        @list = []

    add: (cacheImage) ->
        @list.push cacheImage

    remove: (cacheImage) ->
        @list = @list.filter (image) -> image != cacheImage


class ImageManager extends ImageList
    constructor: ->
        @list = []
        @map = myMap
        @asideNode = document.getElementById 'image-container'
        @select = new ImageList()

    arrayBufferToBinaryString = (arraybuffer) ->
        u8 = new Uint8Array arraybuffer
        charCodeToChar = String.fromCharCode
        (charCodeToChar charCode for charCode in u8).join ''

    addFromBlob: (blob) ->
        url = URL.createObjectURL blob

        reader = new FileReader()
        whenArrayBufferRead = =>
            image = new CacheImage(
                url
                arrayBufferToBinaryString reader.result
            )
            @add image
            if image.exif.gps
                @show image
            else
                @showAside image

        reader.onload = whenArrayBufferRead
        reader.readAsArrayBuffer blob

    show: (image) ->
        @map.showPoint image

    showAside: (image) ->
        @asideNode.appendChild image.toHTMLNode()

    addFromURL: (url) ->
        request = new XMLHttpRequest()
        request.open 'GET', url, true
        request.responseType = 'blob'
        request.onreadystatechange = =>
            req = request
            if req.readyState == 4 && req.status == 200
                @addFromBlob req.response
        request.send ''

    getSelectedImages: getSelectedImages

spexif.imageManager = new ImageManager()


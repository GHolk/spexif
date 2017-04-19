
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
            @show image

        reader.onload = whenArrayBufferRead
        reader.readAsArrayBuffer blob

    show: (image) ->
        if image.mapPoint
            @showInMap image
        else
            @showAside image

    showInMap: (image) ->
        @map.showPoint image

    showAside: (image) ->
        @asideNode.appendChild image.toHTMLNode()

    removeFromMap: (image) ->
        @map.removePoint image

    updatePoint: (image) ->
        @removeFromMap image
        image.updatePoint()
        @show image

    addFromURL: (url) ->
        request = new XMLHttpRequest()
        request.open 'GET', url, true
        request.responseType = 'blob'
        request.onreadystatechange = =>
            if request.readyState == 4 && request.status == 200
                @addFromBlob request.response
        request.send ''

    getChangedImages: ->
        @list.filter (cacheImage) -> cacheImage.change
    getSelectedImages: ->
        @list.filter (cacheImage) ->
            cacheImage.toHTMLNode().getElementsByTagName('input')[0].checked

spexif.imageManager = new ImageManager()


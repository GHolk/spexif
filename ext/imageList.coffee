
myMap = spexif.myMap
CacheImage = spexif.CacheImage
getSelectedImages = spexif.domHelper.getSelectedImages


class ImageManager
    add: (cacheImage) ->
        @list.push cacheImage

    remove: (cacheImage) ->
        @list = @list.filter (image) -> image != cacheImage

    constructor: ->
        @list = []
        @map = myMap
        @asideNode = document.getElementById 'image-container'

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
                blob
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
        @list.filter (cacheImage) -> cacheImage.select()

    writeImages: (imageArray = @getSelectedImages()) ->
        imageArray.forEach (image) ->
            image.updateImage()
        @selectImages imageArray

    selectImages: (imageArray = @list) ->
        imageArray.forEach (image) -> image.select true

    clearSelect: (imageArray = @list) ->
        imageArray.forEach (image) -> image.select false

    invertSelect: (imageArray = @list) ->
        imageArray.forEach (image) ->
            isCheck = image.select()
            image.select !isCheck

    selectByDateInterval: (startDate, endDate, selectMethod) ->
        if typeof selectMethod != 'function'
            selectMethod = (image) -> image.select true
        @list
            .filter (image) ->
                !(image.exif.date < startDate) &&
                !(image.exif.date > endDate)
            .forEach selectMethod

spexif.imageManager = new ImageManager()


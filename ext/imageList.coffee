
myMap = spexif.myMap
CacheImage = spexif.CacheImage
getSelectedImages = spexif.domHelper.getSelectedImages


class ImageManager
    add: (cacheImage) ->
        @list.push cacheImage

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
        theImageList = this
        whenArrayBufferRead = ->
            image = new CacheImage(
                url
                arrayBufferToBinaryString @result
                blob
            )
            theImageList.add image
            theImageList.show image

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

    addFromURL: (url) ->
        fileName = url.replace /^.*\//, ''
        request = new XMLHttpRequest()
        request.open 'GET', url, true
        request.responseType = 'blob'
        addBlobImageToList = @addFromBlob.bind this
        request.onload = ->
            addBlobImageToList new File [@response], fileName
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

    selectByDate: (startDate, endDate, selectMethod) ->
        if typeof selectMethod != 'function'
            selectMethod = (image) -> image.select true
        @list
            .filter (image) ->
                !(image.exif.date < startDate) &&
                !(image.exif.date > endDate)
            .forEach selectMethod

    remove: (imageArray = @getSelectedImages()) ->
        imageArray.forEach (image) -> myMap.removePoint image
        @list = @list.filter (image) ->
            imageArray.every (imageInArray) ->
                imageInArray != image

spexif.imageManager = new ImageManager()


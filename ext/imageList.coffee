
myMap = spexif.myMap
CacheImage = spexif.CacheImage
getSelectedImages = spexif.domHelper.getSelectedImages
speaker = spexif.speaker


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
        reader.onload = ->
            image = new CacheImage(
                url
                arrayBufferToBinaryString @result
                blob
            )
            theImageList.add image
            theImageList.show image

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

    changeImageNameInServer: []

    addFromURL: (url) ->
        fileName = decodeURIComponent url.replace /^.*\//, ''
        request = new XMLHttpRequest()
        request.open 'GET', url
        if (@changeImageNameInServer.some (name) -> name == fileName)
            request.setRequestHeader 'Cache-Control', 'no-cache'
            @changeImageNameInServer =
                @changeImageNameInServer.filter (name) -> name != fileName
        request.responseType = 'blob'
        addBlobImageToList = @addFromBlob.bind this

        request.onload = ->
            addBlobImageToList new File [@response], fileName

        theImageNameList = @changeImageNameInServer
        request.onerror = ->
            theImageNameList.push fileName
            speaker.errorFriendly(
                new Error "can not load image #{fileName} from server."
            )
            speaker.error new Error "can not load #{url}"

        request.send()

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
            ! imageArray.some (imageInput) ->
                imageInput == image

    selectByCircle: (gps, radius) ->
        @list
            .filter (image) ->
                radius >= myMap.distanceBetweenPoint gps, image.mapPoint
            .forEach (image) -> image.select true

spexif.imageManager = new ImageManager()


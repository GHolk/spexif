
myMap = spexif.myMap
speaker = spexif.speaker
FilterPiexif = spexif.FilterPiexif
createInfoNode = spexif.domHelper.createInfoNode

binaryStringToImage64 = (binaryString, fileName) ->
    u8 = new Uint8Array binaryString.length
    for x,i in u8
        u8[i] = binaryString.charCodeAt i
    blob = new File [u8], fileName, {type: 'image/jpeg'}
    return new Image64 (URL.createObjectURL blob), binaryString, blob

class Image64
    constructor: (url, data, blob) ->
        if url.slice(0,23) == 'data:image/jpeg;base64,'
            @dataType = 'dataURL'
            @url = url
            @data = atob url.slice 23
        else if data.slice(0,2) == "\xff\xd8"
            @dataType = 'binaryString'
            @url = url || 'data:image/jpeg;base64,' + btoa data
            @data = data
            @blob = blob
        else
            speaker.errorFriendly 'input is not jpeg file!'
            throw new Error 'input is not jpeg file!'

    toString: -> @data


class CacheImage
    createEXIF = (data) -> new FilterPiexif piexif.load data
    createPoint = (image) ->
        if image.exif.gps.length == 2
            myMap.createPoint image
        else
            null

    constructor: (url, data, blob) ->
        @fullImage = new Image64 url, data, blob
        @exif = createEXIF data
        if @exif.thumbnail
            @thumbnailImage = new Image64 '', @exif.thumbnail
        else
            @thumbnailImage = @fullImage
        @updateHTMLNode()
        @mapPoint = createPoint this

    updateImage: ->
        newImageString = piexif.insert(
            @exif.getBinaryString()
            @fullImage.data
        )
        oldBlob = @fullImage.blob
        @fullImage = binaryStringToImage64 newImageString, oldBlob.name
        @updateHTMLNode()
        @updatePoint()
        speaker.logFriendly 'update image exif.'

    change: null  # date object at change time if change.
    HTMLNode: null
    updatePoint: -> @mapPoint.setPopupContent @HTMLNode
    updateHTMLNode: ->
        isChecked = @select() if @HTMLNode
        @HTMLNode = createInfoNode this
        @select isChecked if isChecked

    select: (tf) ->
        checkNode = @HTMLNode.getElementsByTagName('input')[0]
        if tf == true
            checkNode.checked = true
        else if tf == false
            checkNode.checked = false
        else
            return checkNode.checked


spexif.CacheImage = CacheImage



myMap = spexif.myMap
speaker = spexif.speaker
FilterPiexif = spexif.FilterPiexif
createInfoNode = spexif.domHelper.createInfoNode

binaryStringToImage64 = (binaryString) ->
    u8 = new Uint8Array binaryString.length
    for x,i in u8
        u8[i] = binaryString.charCodeAt i
    blob = new Blob [u8], {type: 'image/jpeg'}
    return new Image64 (URL.createObjectURL blob), binaryString

class Image64
    constructor: (url, data) ->
        if url.slice(0,23) == 'data:image/jpeg;base64,'
            @dataType = 'dataURL'
            @url = url
            @data = atob url.slice 23
        else if data.slice(0,2) == "\xff\xd8"
            @dataType = 'binaryString'
            @url = url || 'data:image/jpeg;base64,' + btoa data
            @data = data
        else
            speaker.errorFriendly 'input is not jpeg file!'
            throw 'input is not jpeg file!' + '\n' + data

    toString: -> @data


class CacheImage
    createEXIF = (data) -> new FilterPiexif piexif.load data
    createPoint = (image) ->
        if image.exif.gps.length == 2
            myMap.createPoint image
        else
            null

    constructor: (url, data) ->
        @fullImage = new Image64 url, data
        @exif = createEXIF data
        if @exif.thumbnail
            @thumbnailImage = new Image64 '', @exif.thumbnail
        else
            @thumbnailImage = @fullImage
        @updateHTMLNode()
        @updatePoint()

    updateImage: ->
        newImageString = piexif.insert(
            @exif.getBinaryString()
            piexif.remove @fullImage.data
        )
        @fullImage = binaryStringToImage64 newImageString
        @updateHTMLNode()

    change: null  # date object at change time if change.
    HTMLNode: null
    updatePoint: -> @mapPoint = createPoint this
    updateHTMLNode: ->
        isChecked = @select() if @HTMLNode
        @HTMLNode = createInfoNode this
        @select isChecked if isChecked
    select: (tf) ->
        if tf == true
            @HTMLNode.getElementsByTagName('input')[0].checked = true
        else if tf == false
            @HTMLNode.getElementsByTagName('input')[0].checked = false
        else
            @HTMLNode.getElementsByTagName('input')[0].checked


spexif.CacheImage = CacheImage


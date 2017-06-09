
myMap = spexif.myMap
speaker = spexif.speaker
FilterPiexif = spexif.FilterPiexif
createInfoNode = spexif.domHelper.createInfoNode

binaryStringToBlob = (binaryString) ->
    u8 = new Uint8Array binaryString.length
    for x,i in u8
        u8[i] = binaryString.charCodeAt i
    return blob = new Blob [u8], {type: 'image/jpeg'}

blobToImage64 = (blob) ->
    new Image64 (URL.createObjectURL blob), binaryString

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
        @updatePoint()

    updateImage: ->
        newImageString = piexif.insert(
            @exif.getBinaryString()
            piexif.remove @fullImage.data
        )
        @fullImage = blobToImage64 binaryStringToBlob newImageString
        @HTMLNode.getElementsByTagName('a')[0].href = @fullImage.url

    change: null  # date object at change time if change.
    updatePoint: -> @mapPoint = createPoint this
    toHTMLNode: -> @HTMLNode || @HTMLNode = createInfoNode this

spexif.CacheImage = CacheImage


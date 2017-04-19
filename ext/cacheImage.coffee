
myMap = spexif.myMap
speaker = spexif.speaker
FilterPiexif = spexif.FilterPiexif
createInfoNode = spexif.domHelper.createInfoNode

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
    createImage = (url, data) -> new Image64 url, data
    createPoint = (image) ->
        if image.exif.gps.length == 2
            myMap.createPoint image
        else
            null

    constructor: (url, data) ->
        @fullImage = createImage url, data
        @exif = createEXIF data
        if @exif.thumbnail
            @thumbnailImage = createImage '', @exif.thumbnail
        @updatePoint()

    updatePoint: ->
        @mapPoint = createPoint this

    toHTMLNode: -> @HTMLNode || @HTMLNode = createInfoNode this

spexif.CacheImage = CacheImage

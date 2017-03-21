
myMap = spexif.myMap
speaker = spexif.speaker
imageList = spexif.imageList
FilterPiexif = spexif.FilterPiexif

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
            speaker.errorFreindly 'input is not jpeg file!'
            throw 'input is not jpeg file!' + '\n' + data

    createHTMLNode = ->
        image = document.createElement 'img'
        image.src = @url
        return image

    toString: -> @data
    toHTMLNode: -> @HTMLNode || createHTMLNode.call this


class CacheImage

    createEXIF = (data) -> new FilterPiexif piexif.load data
    createImage = (url, data) -> new Image64 url, data
    createPoint = (image) -> myMap.createPoint image

    constructor: (url, data) ->
        @fullImage = createImage url, data
        @exif = createEXIF data
        if @exif.thumbnail
            @thumbnailImage = createImage '', @exif.thumbnail
        @mapPoint = createPoint this if @exif.gps

    createHTMLNode = ->
        div = document.createElement 'div'
        div.className = 'image-info'
        div.appendChild (
            @thumbnailImage?.toHTMLNode() || @fullImage.toHTMLNode()
        )
        div.appendChild @exif.toHTMLNode()
        return div

    toHTMLNode: -> @HTMLNode || @HTMLNode = createHTMLNode.call this

spexif.CacheImage = CacheImage

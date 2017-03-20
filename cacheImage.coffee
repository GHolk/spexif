
myMap = spexif.myMap
speaker = spexif.speaker
imageList = spexif.imageList
FilterPiexif = spexif.FilterPiexif

class Image64
    constructor: (data) ->
        if data.slice(0,23) == 'data:image/jpeg;base64,'
            @dataURL = data
        else if data.match /\W/
            @dataURL = 'data:image/jpeg;base64,' + btoa data
        else
            @dataURL = 'data:image/jpeg;base64,' + data

    createHTMLNode = ->
        image = document.createElement 'img'
        image.src = @dataURL
        return image

    toString: -> @dataURL
    toHTMLNode: -> @HTMLNode || createHTMLNode.call this

class CacheImage

    createEXIF = (dataURL) -> new FilterPiexif piexif.load dataURL
    createImage = (dataURL) -> new Image64 dataURL
    createPoint = (image) -> myMap.createPoint image

    constructor: (dataURL) ->
        if dataURL.slice(0,23) != 'data:image/jpeg;base64,'
            speaker.errorFreindly 'input is not jpeg file!'
            throw 'input is not jpeg file!' + '\n' + dataURL

        @fullImage = createImage dataURL
        @exif = createEXIF dataURL
        if @exif.thumbnail
            @thumbnailImage = createImage @exif.thumbnail
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

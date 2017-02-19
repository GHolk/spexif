
myMap = spexif.myMap
speaker = spexif.speaker
imageList = spexif.imageList
FilterPiexif = spexif.FilterPiexif

class CacheImage
    constructor: (dataURL) ->
        if dataURL.slice(0,22) != 'data:image/jpeg;base64'
            speaker.errorFreindly 'input is not jpeg file!'
            throw 'input is not jpeg file!'

        @dataURL = dataURL
        @createEXIF()
        @createImageNode()
        @createHTMLNode()
        @createPoint() if @exif.gps
        imageList.add this

    createPoint: ->
        @mapPoint = myMap.createPoint this

    createImageNode: ->
        imageNode = document.createElement 'img'
        imageNode.src = @dataURL
        @imageNode = imageNode

    createHTMLNode: ->
        @HTMLNode = @exif.HTMLNode

    createEXIF: ->
        halfExif = piexif.load @dataURL
        @exif = new FilterPiexif halfExif

spexif.CacheImage = CacheImage

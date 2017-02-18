
myMap = spexif.myMap
speaker = spexif.speaker

class ImageList extends Array
    constructor: ->
        @map = myMap

    add: (image) ->
        @push image
        @show image

    show: (image) ->
        @map.showPoint image

imageList = new ImageList()


class CacheImage
    constructor: (dataURL) ->
        if dataURL.slice(0,22) != 'data:image/jpeg;base64'
            throw speaker.errorFreindly 'input is not jpeg file!'

        @dataURL = dataURL
        @createEXIF()
        @createImageNode()
        @createHTMLNode()
        @createPoint()
        imageList.add this

    createPoint: ->
        @mapPoint = myMap.createPoint this

    createImageNode: ->
        imageNode = document.createElement 'img'
        imageNode.src = @dataURL
        @imageNode = imageNode

    createHTMLNode: ->
        HTMLNode = document.createElement 'div'
        HTMLNode.className = 'image-info'
        HTMLNode.appendChild @imageNode
        HTMLNode.appendChild @exif.HTMLNode
        @HTMLNode = HTMLNode

    createEXIF: ->
        halfExif = piexif.load @dataURL
        @exif = new FilterPiexif halfExif


class FilterPiexif
    constructor: (exif) ->
        try
            @date = @getDate(exif.Exif)
        catch err
            speaker.error err
            speaker.errorFreindly "can't get date of photo. "

        try
            @maker = @getMaker(exif['0th'])
        catch err
            speaker.error err
            speaker.errorFreindly "can't get camera of photo. "

        try
            @gps = [
                @getGPS(exif.GPS, "GPSLongitude")
                @getGPS(exif.GPS, "GPSLatitude")
            ]
        catch err
            speaker.error err
            speaker.errorFreindly "can't get gps data of photo. "

        @createHTMLNode()

    getMaker: (exif) -> 
        exif[piexif.ImageIFD.Make].trim()

    getDate: (exif) ->
        date = exif[ piexif.ExifIFD.DateTimeOriginal ].split ' '
        date[0] = date[0].replace /:/g, '-'
        date.join 'T'

    getGPS: (exif, key) ->
        dms = exif[ piexif.GPSIFD[key] ]
        ratio = 1
        decimal = 0
        for part in dms
            decimal += part[0] / part[1] / ratio
            ratio *= 60
        return decimal

    createHTMLNode: ->
        HTMLNode = document.createElement 'pre' 
        HTMLNode.textContent = [@date, @maker, @gps].join '\n'
        @HTMLNode = HTMLNode


spexif.CacheImage = CacheImage
spexif.imageList = imageList


speaker = spexif.speaker

class FilterPiexif
    constructor: (exif) ->
        try
            @date = @getDate exif.Exif
        catch err
            speaker.error err
            speaker.errorFreindly "can't get date of photo. "

        try
            @maker = @getMaker exif['0th']
        catch err
            speaker.error err
            speaker.errorFreindly "can't get camera of photo. "

        try
            @gps = [
                @getGPS exif.GPS, "GPSLongitude"
                @getGPS exif.GPS, "GPSLatitude"
            ]
        catch err
            speaker.error err
            speaker.errorFreindly "can't get gps data of photo. "

        try
            @thumbnailBase64 = btoa exif.thumbnail
        catch err
            speaker.error err
            speaker.errorFreindly "can't get thumbnail of photo. "

        @createTextNode()
        @createThumbnailNode()
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

    createTextNode: ->
        textNode = document.createElement 'pre' 
        textNode.textContent = [@date, @maker, @gps].join '\n'
        @textNode = textNode

    createThumbnailNode: ->
        imageNode = document.createElement 'img'
        imageNode.src = 
            'data:' + 'image/jpeg;' + 'base64,' + 
            @thumbnailBase64
        @imageNode = imageNode

    createHTMLNode: ->
        HTMLNode = document.createElement 'div'
        HTMLNode.appendChild @imageNode
        HTMLNode.appendChild @textNode
        @HTMLNode = HTMLNode

spexif.FilterPiexif = FilterPiexif


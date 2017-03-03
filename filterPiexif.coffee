
speaker = spexif.speaker

class FilterPiexif
    getMaker = (exif) -> exif[piexif.ImageIFD.Make].trim()
    getDate = (exif) -> exif[ piexif.ExifIFD.DateTimeOriginal ]
    getGPS = (exif, key) ->
        dms = exif[ piexif.GPSIFD[key] ]
        ratio = 1
        decimal = 0
        for part in dms
            decimal += part[0] / part[1] / ratio
            ratio *= 60
        return decimal

    constructor: (allExif) ->
        try
            @date = getDate allExif.Exif
        catch err
            speaker.error err
            speaker.errorFreindly "can't get date of photo. "
        try
            @maker = getMaker allExif['0th']
        catch err
            speaker.error err
            speaker.errorFreindly "can't get camera of photo. "

        try
            @gps = [
                getGPS allExif.GPS, "GPSLongitude"
                getGPS allExif.GPS, "GPSLatitude"
            ]
        catch err
            speaker.error err
            speaker.errorFreindly "can't get gps data of photo. "

        try
            if ! @thumbnail = allExif.thumbnail
                throw allExif.thumbnail
        catch err
            speaker.error err
            speaker.errorFreindly "can't get thumbnail of photo. "

    createHTMLNode = ->
        preNode = document.createElement 'pre'
        preNode.textContent = [@date, @maker, @gps].join '\n'
        return preNode

    toHTMLNode: -> @HTMLNode || @HTMLNode = createHTMLNode.call this

spexif.FilterPiexif = FilterPiexif


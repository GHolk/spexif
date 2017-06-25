
speaker = spexif.speaker

class FilterPiexif
    exifDateToDateObject = (exifDate) ->
        [yearPart, timePart] = exifDate.trim().split ' '
        yearPart = yearPart.replace /:/g, '-'
        return new Date "#{yearPart} #{timePart}"

    dateObjectToExifDate = (date) ->
        [yearPart, timePart] = date.toISOString().split 'T'
        yearPart = yearPart.replace /-/g, ':'
        timePart = timePart.replace /\..*$/, ''
        return "#{yearPart} #{timePart}"

    get =
        maker: (exif) -> exif['0th'][piexif.ImageIFD.Make].trim()
        date: (exif) ->
            exifDateToDateObject exif.Exif[piexif.ExifIFD.DateTimeOriginal]
        oneOfGPS: (exif, key) ->
            dms = exif.GPS[ piexif.GPSIFD[key] ]
            orient = exif.GPS[ piexif.GPSIFD["#{key}Ref"] ]
            decimalDegree = dms
                .map (part) -> part[0] / part[1]
                .reduce ((sum, hex, i) -> sum + hex/(60**i)), 0

            switch orient
                when 'N', 'E'
                    return decimalDegree
                when 'S', 'W'
                    return -decimalDegree
                else
                    return decimalDegree

        gps: (exif) ->
            getOneOfGPS = @oneOfGPS.bind this
            ['GPSLongitude', 'GPSLatitude']
                .map (key) => getOneOfGPS exif, key

    set =
        maker: (exif, maker) -> exif['0th'][piexif.ImageIFD.Make] = maker
        date: (exif, date) ->
            exif.Exif[ piexif.ExifIFD.DateTimeOriginal ] =
                dateObjectToExifDate date

        oneOfGPS: (exif, key, dmsText) ->
            toInt = (f) -> Math.floor f
            toFrac = (f, i) -> [(toInt f*i), i]
            gpsArray = do (dmsText) ->
                float = Math.abs Number dmsText
                return [
                    toFrac float, 1
                    toFrac float*60%60, 1
                    toFrac float*60*60%60, 10000
                ]
            exif.GPS[ piexif.GPSIFD[key] ] = gpsArray
            exif.GPS[ piexif.GPSIFD["#{key}Ref"] ] = switch
                when Number dmsText >= 0
                    if key == 'GPSLongitude' then 'E'
                    else 'N'
                else # Number dmsText < 0
                    if key == 'GPSLongitude' then 'W'
                    else 'S'


        gps: (exif, dms) ->
            dms = dms.split ',' if typeof dms == 'string'
            ['GPSLongitude','GPSLatitude'].forEach (key, i) ->
                set.oneOfGPS exif, key, dms[i]

    gps: [119,23]
    maker: 'iPhone 1'
    date: new Date 0
    constructor: (allExif) ->
        @allExif = allExif
        for key in ['date', 'maker', 'gps']
            try
                @[key] = get[key] allExif
            catch err
                speaker.error err
                speaker.errorFriendly "can't get #{key} of photo. "
        try
            if ! @thumbnail = allExif.thumbnail
                throw allExif.thumbnail
        catch err
            speaker.error err
            speaker.errorFriendly "can't get thumbnail of photo. "

    update: ->
        for key in ['date','maker','gps']
            try
                set[key] @allExif, @[key]
            catch err
                speaker.error err
                speaker.errorFriendly "can't set #{key} of photo. "

    getBinaryString: -> piexif.dump @allExif

    toString: -> """
        #{@date.toISOString()}
        #{@maker}
        #{@gps}
    """

spexif.FilterPiexif = FilterPiexif

window.updateImageToNode = (cacheImage) ->
    newExifByte = piexif.dump cacheImage.exif.allExif
    newJpegByte = piexif.insert newExifByte, cacheImage.fullImage.data
    img = document.createElement 'img'
    img.src = 'data:image/jpeg;base64,' + btoa newJpegByte
    return img

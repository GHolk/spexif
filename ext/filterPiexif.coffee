
speaker = spexif.speaker

class FilterPiexif
    get =
        maker: (exif) -> exif['0th'][piexif.ImageIFD.Make].trim()
        date: (exif) -> exif.Exif[ piexif.ExifIFD.DateTimeOriginal ]
        oneOfGPS: (exif, key) ->
            dms = exif.GPS[ piexif.GPSIFD[key] ]
            ratio = 1
            decimal = 0
            dms
                .map (part) -> part[0] / part[1]
                .reduce ((sum, hex, i) -> sum + hex/(60**i)), 0

        gps: (exif) ->
            ['GPSLongitude', 'GPSLatitude']
                .map (key) => @oneOfGPS exif, key

    set =
        maker: (exif, maker) -> exif['0th'][piexif.ImageIFD.Make] = maker
        date: (exif, date) ->
            exif.Exif[ piexif.ExifIFD.DateTimeOriginal ] = date

        oneOfGPS: (exif, key, dmsText) ->
            toInt = (f) -> Math.floor f
            toFrac = (f, i) -> [(toInt f*i), i]
            exif.GPS[ piexif.GPSIFD[key] ] = do (dmsText) ->
                float = Number dmsText
                [float, float*60%60, float*60*60%60].map (fa) -> [
                    toFrac fa[0], 1
                    toFrac fa[1], 1
                    toFrac fa[2], 10000
                ]
        gps: (exif, dms) ->
            dms = dms.split ',' if typeof dms == 'string'
            ['GPSLongitude','GPSLatitude'].forEach (key, i) ->
                set.oneOfGPS exif, key, dms[i]

    gps: []
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

    createHTMLNode = ->
        preNode = document.createElement 'pre'
        preNode.textContent = [@date, @maker, @gps].join '\n'
        return preNode

    toHTMLNode: -> @HTMLNode || @HTMLNode = createHTMLNode.call this

spexif.FilterPiexif = FilterPiexif



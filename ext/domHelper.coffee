
template = do ->
    node = document
        .getElementById 'template'
        .getElementsByClassName('image-template')[0]
        .cloneNode true
    node.className = 'image-info'
    return node

updateExif = (image, text) ->
    exifArray = text.split /\n/g
    exifArray[2] = exifArray[2].split(/,/).map (s) -> Number(s)
    exif = image.exif
    [exif.date, exif.maker, exif.gps] = exifArray
    image.exif.update()
    image.change = new Date()
    spexif.imageManager.updatePoint image

createInfoNode = (cacheImage) ->
    newNode = template.cloneNode true
    newNode.getElementsByTagName('img')[0].src =
        cacheImage.thumbnailImage.url

    exif = cacheImage.exif
    textarea = newNode.getElementsByTagName('textarea')[0]
    textarea.value = """
        #{exif.date.trim()}
        #{exif.maker.trim()}
        #{exif.gps.toString().trim()}
    """
    textarea.addEventListener 'change', ->
        updateExif cacheImage, @value
        @parentNode.getElementsByTagName('input')[0].checked = true

    return newNode

spexif.domHelper = {createInfoNode}


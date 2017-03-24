
imageManager = spexif.imageManager

template = do ->
    node = document
        .getElementById 'template'
        .getElementsByClassName('image-template')[0]
        .cloneNode true
    node.className = 'image-info'
    return node

whenTextAreaChange = ->
    [date,maker,gps] = @value.split /\n/g
    gps = gps.split ','
    exif = @parentNode.cacheImage.exif
    for key,value of {date,maker}
        exif.key = value
    exif.gps = gps.map Number

createInfoNode = (cacheImage) ->
    newNode = template.cloneNode true
    newNode.cacheImage = cacheImage
    newNode.getElementsByTagName('img')[0].src =
        cacheImage.thumbnailImage.url

    exif = cacheImage.exif
    textarea = newNode.getElementsByTagName('textarea')[0]
    textarea.value = """
        #{exif.date}
        #{exif.maker}
        #{exif.gps}
    """

    textarea.onchange = whenTextAreaChange

    return newNode

getSelectedImages = ->
    for checkbox in document.getElementsByTagName 'input' when checkbox.checked
        checkbox.parentNode.cacheImage

spexif.domHelper = {createInfoNode,getSelectedImages}

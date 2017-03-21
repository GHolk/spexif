
imageManager = spexif.imageManager

template = do ->
    node = document
        .getElementById 'template'
        .getElementsByClassName('image-template')[0]
        .cloneNode true
    node.className = 'image-info'
    return node

createInfoNode = (cacheImage) ->
    newNode = template.cloneNode true
    newNode.cacheImage = cacheImage
    newNode.getElementsByTagName('img')[0].src =
        cacheImage.thumbnailImage.url

    exif = cacheImage.exif
    newNode.getElementsByTagName('pre')[0].textContent = """
        #{exif.date}
        #{exif.maker}
        #{exif.gps}
    """

    return newNode

getSelectedImages = ->
    for checkbox in document.getElementsByTagName 'input' when checkbox.checked
        checkbox.parentNode.cacheImage

spexif.domHelper = {createInfoNode,getSelectedImages}

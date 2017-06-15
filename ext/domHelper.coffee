
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
    exifArray[0] = new Date exifArray[0]
    exif = image.exif
    [exif.date, exif.maker, exif.gps] = exifArray
    image.exif.update()
    image.change = new Date()
    spexif.imageManager.updatePoint image

createInfoNode = (cacheImage) ->
    newNode = template.cloneNode true
    newNode.getElementsByTagName('img')[0].src =
        cacheImage.thumbnailImage.url
    newNode.getElementsByTagName('a')[0].href = cacheImage.fullImage.url

    exif = cacheImage.exif
    trim = (s) -> String(s).trim()
    textarea = newNode.getElementsByTagName('textarea')[0]
    textarea.value = cacheImage.exif.toString()
    textarea.addEventListener 'change', ->
        updateExif cacheImage, @value
        @parentNode.getElementsByTagName('input')[0].checked = true

    return newNode

document.getElementById 'update-image-binary'
    .onclick = -> spexif.imageManager.writeImages()
document.getElementById 'clear-select'
    .onclick = -> spexif.imageManager.clearSelect()
document.getElementById 'invert-select-image'
    .onclick = -> spexif.imageManager.invertSelect()

spexif.domHelper = {createInfoNode}


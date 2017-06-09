
CacheImage = spexif.CacheImage
imageManager = spexif.imageManager

whenInputFiles = (evt) ->
    files = evt.target.files

    for file in files
        imageManager.addFromBlob file

(document.getElementsByTagName 'input')[0].addEventListener 'change', whenInputFiles, true



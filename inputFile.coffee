
CacheImage = spexif.CacheImage
imageList = spexif.imageList

whenInputFiles = (evt) ->
    window.files = evt.target.files

    for file in files
        imageList.addFromBlob file

(document.getElementsByTagName 'input')[0].addEventListener 'change', whenInputFiles, true

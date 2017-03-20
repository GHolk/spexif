
CacheImage = spexif.CacheImage
imageList = spexif.imageList

webFile =
    read: (file, callback) ->
        reader = new FileReader()
        reader.onload = callback
        reader.readAsDataURL file

    newCacheImage: (evt) ->
        imageList.add evt.target.result


whenInputFiles = (evt) ->
    files = evt.target.files

    for file in files
        webFile.read file, webFile.newCacheImage

(document.getElementsByTagName 'input')[0].addEventListener 'change', whenInputFiles, true

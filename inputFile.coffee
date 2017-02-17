
webFile =
    read: (file, callback) ->
        reader = new FileReader()
        reader.onload = callback
        reader.readAsDataURL file

    newCacheImage: (evt) ->
        dataURL = evt.target.result
        image = new CacheImage dataURL
        image.createHTMLTag()
        document.body.appendChild image.HTMLTag


whenInputFiles = (evt) ->
    files = evt.target.files

    for file in files
        webFile.read file, webFile.newCacheImage

(document.getElementsByTagName 'input')[0].addEventListener 'change', whenInputFiles, true


class CacheImage
    constructor: (file) ->
        reader = new FileReader()
        reader.onload = @fromDataURL.bind this
        reader.readAsDataURL file

    fromDataURL: (somewhat) ->
        if typeof somewhat != 'string'
            dataURL = somewhat.target.result
        else
            dataURL = somewhat

        console.dataURL
        imageTag = document.createElement 'img'
        imageTag.src = dataURL
        document.body.appendChild imageTag
        @html = imageTag

whenInputFiles = (evt) ->
    files = evt.target.files

    for file in files
        new CacheImage file

(document.getElementsByTagName 'input')[0].addEventListener 'change', whenInputFiles, true

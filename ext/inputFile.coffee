
CacheImage = spexif.CacheImage
imageManager = spexif.imageManager
speaker = spexif.speaker

whenInputFiles = (evt) ->
    files = evt.target.files

    for file in files
        imageManager.addFromBlob file

fileForm = document.getElementById 'load-image'

fileForm
    .elements[0]
    .addEventListener 'change', whenInputFiles, true

fileForm.addEventListener 'submit', (evt) ->
    evt.preventDefault()

    fileEntry = @elements[0].name
    imageList = spexif.imageManager.getSelectedImages()

    if imageList.length > 0
        formData = new FormData this
        formData.delete fileEntry

        for image in imageList
            formData.append fileEntry, image.fullImage.blob

        xmlRequest = new XMLHttpRequest()
        xmlRequest.open @method.toUpperCase(), @action
        xmlRequest.onload = ->
            speaker.logFriendly 'successful upload selected image.'
            for image in imageList
                imageManager.changeImageNameInServer.push(
                    image.fullImage.blob.name
                )
        xmlRequest.onerror = ->
            speaker.errorFriendly new Error 'can not upload selected image!'
        xmlRequest.send formData

    else
        speaker.errorFriendly 'no image selected.'


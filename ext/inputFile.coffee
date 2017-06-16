
CacheImage = spexif.CacheImage
imageManager = spexif.imageManager

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
    formData = new FormData()
    entryName = @elements[0].name
    spexif.imageManager.getSelectedImages().forEach (image) ->
        formData.append entryName, image.fullImage.blob

    xmlRequest = new XMLHttpRequest()
    xmlRequest.open @method.toUpperCase(), @action
    xmlRequest.send formData



CacheImage = spexif.CacheImage
imageManager = spexif.imageManager

whenInputFiles = (evt) ->
    files = evt.target.files

    for file in files
        imageManager.addFromBlob file

fileForm = document.getElementById 'load-image'

fileForm.children[0].addEventListener 'change', whenInputFiles, true
fileForm.children[1].addEventListener 'click', (evt) ->
    evt.preventDefault()
    formData = new FormData()
    window.uploadImages = imageManager.getSelectedImages()


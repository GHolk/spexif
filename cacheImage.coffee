
window.imageList = []

class CacheImage
    constructor: (dataURL) ->
        @dataURL = dataURL
        window.imageList.push @createHTMLTag()

    createHTMLTag: ->
        imageTag = document.createElement 'img'
        imageTag.src = @dataURL
        @HTMLTag = imageTag

window.CacheImage = CacheImage


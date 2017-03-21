
domHelper = {}

class ImageNode =
    template: do ->
        node = document
            .getElementById 'template'
            .getElementsByClassName('image-template')[0]
            .cloneNode true
        node.remove()
        node.className = 'image-info'
        return node

    checkImage = ->
        if @checked
            imageList.selectImages.add @parentNode.cacheImage
        else
            imageList.selectImages.remove @parentNode.cacheImage


    constructor: (cacheImage) ->
        newNode = @node.cloneNode true
        newNode.cacheImage = cacheImage
        newNode.getElementsByTagName('img').src = cacheImage.url

        exif = cacheImage.exif
        newNode.getElementsByTagName('pre').textContent = """
            #{exif.date}
            #{exif.maker}
            #{exif.gps}
        """
        newNode.getElementsByTagName('input').onchange = checkImage
        return node


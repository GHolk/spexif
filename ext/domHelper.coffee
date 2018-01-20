
template = do ->
    node = document
        .getElementById 'template'
        .getElementsByClassName('image-template')[0]
        .cloneNode true
    node.className = 'image-info'
    return node

updateExif = (image, text) ->
    exifArray = text.split /\n/g
    exifArray[2] = exifArray[2].split(/,/).map (s) -> Number(s)
    exifArray[0] = new Date exifArray[0]
    exif = image.exif
    [exif.date, exif.maker, exif.gps] = exifArray
    image.exif.update()
    image.change = new Date()
    spexif.myMap.movePoint image, exifArray[2]

createInfoNode = (cacheImage) ->
    newNode = template.cloneNode true
    newNode.getElementsByTagName('img')[0].src = cacheImage.fullImage.url
    newNode.getElementsByTagName('a')[0].href = cacheImage.fullImage.url

    exif = cacheImage.exif
    trim = (s) -> String(s).trim()
    textarea = newNode.getElementsByTagName('textarea')[0]
    textarea.value = cacheImage.exif.toString()
    textarea.addEventListener 'change', ->
        updateExif cacheImage, @value
        @parentNode.getElementsByTagName('input')[0].checked = true

    return newNode

document.getElementById 'update-image-binary'
    .onclick = -> spexif.imageManager.writeImages()

document.getElementById 'clear-select'
    .onclick = -> spexif.imageManager.clearSelect()

document.getElementById 'invert-select-image'
    .onclick = -> spexif.imageManager.invertSelect()

document.getElementById 'remove-select-image'
    .onclick = -> spexif.imageManager.remove()

document.getElementById('download-select-image').onclick = ->
    spexif.imageManager.getSelectedImages().forEach(
        (image) -> image.HTMLNode.getElementsByTagName('a')[0].click()
    )

# dirty code..., I dont know how write pretty.
# query need form name, but pass form name as argument ugly,
# hard code even more ugly.
dateEntries =
    start: 'DateFrom'
    end: 'DateTo'

queryDateFromServer = (startDate, endDate, url) ->
    addDate = (name, date, array) ->
        if date.valueOf()
            array.push name + '=' + date.toISOString().replace(/T.*$/, '')

    queryArray = []
    queryArray.push 'Type=Time'
    addDate dateEntries.start, startDate, queryArray
    addDate dateEntries.end, endDate, queryArray

    queryString = '?' + queryArray.join '&'

    req = new XMLHttpRequest()
    req.responseType = 'document'
    req.open 'GET', url + queryString
    req.onload = ->
        for img in @response.getElementsByTagName 'img'
            spexif.imageManager.addFromURL img.src
    req.send()


document.getElementById 'date-query'
    .onsubmit = (evt) ->
        evt.preventDefault()

        startDate = new Date @elements[dateEntries.start].value
        endDate = new Date @elements[dateEntries.end].value

        switch @elements['query-from'].value
            when 'local'
                spexif.imageManager.selectByDate startDate, endDate
            when 'server'
                queryDateFromServer startDate, endDate, @action

circle =
    latitude: 'Lat'
    longitude: 'Lon'
    radius: 'Dist'

queryCircleFromServer = (gps, radius, url) ->
    radius /= 1000  # server unit set in kilometer
    addGpsDegree = (type, degree, array) ->
        array.push type + '=' + degree

    queryArray = []
    queryArray.push 'Type=Distance'
    queryArray.push 'Dist=' + radius
    addGpsDegree circle.longitude, gps[0], queryArray
    addGpsDegree circle.latitude, gps[1], queryArray

    queryString = '?' + queryArray.join '&'

    req = new XMLHttpRequest()
    req.responseType = 'document'
    req.open 'GET', url + queryString
    req.onload = ->
        for img in @response.getElementsByTagName 'img'
            spexif.imageManager.addFromURL img.src
    req.send()


document.getElementById 'circle-query'
    .onsubmit = (evt) ->
        evt.preventDefault()

        gps = [
            @elements[circle.longitude]
            @elements[circle.latitude]
        ].map (node) -> Number node.value

        radius = Number @elements[circle.radius].value

        switch @elements['query-from'].value
            when 'local'
                spexif.imageManager.selectByCircle gps, radius
            when 'server'
                queryCircleFromServer gps, radius, @action

document.getElementById 'visual-circle'
    .onclick = (evt) ->
        evt.preventDefault()

        formElements = @form.elements
        spexif.myMap.drawCircle (center, radius) ->
            formElements[circle.longitude].value = center[0]
            formElements[circle.latitude].value = center[1]
            formElements[circle.radius].value = radius

spexif.domHelper = {createInfoNode,queryCircleFromServer}


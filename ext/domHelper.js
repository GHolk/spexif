// Generated by CoffeeScript 1.12.1
(function() {
  var createInfoNode, dateEntries, dateQueryFromServer, queryDateFromServer, template, updateExif;

  template = (function() {
    var node;
    node = document.getElementById('template').getElementsByClassName('image-template')[0].cloneNode(true);
    node.className = 'image-info';
    return node;
  })();

  updateExif = function(image, text) {
    var exif, exifArray;
    exifArray = text.split(/\n/g);
    exifArray[2] = exifArray[2].split(/,/).map(function(s) {
      return Number(s);
    });
    exifArray[0] = new Date(exifArray[0]);
    exif = image.exif;
    exif.date = exifArray[0], exif.maker = exifArray[1], exif.gps = exifArray[2];
    image.exif.update();
    image.change = new Date();
    return spexif.myMap.movePoint(image, exifArray[2]);
  };

  createInfoNode = function(cacheImage) {
    var exif, newNode, textarea, trim;
    newNode = template.cloneNode(true);
    newNode.getElementsByTagName('img')[0].src = cacheImage.thumbnailImage.url;
    newNode.getElementsByTagName('a')[0].href = cacheImage.fullImage.url;
    exif = cacheImage.exif;
    trim = function(s) {
      return String(s).trim();
    };
    textarea = newNode.getElementsByTagName('textarea')[0];
    textarea.value = cacheImage.exif.toString();
    textarea.addEventListener('change', function() {
      updateExif(cacheImage, this.value);
      return this.parentNode.getElementsByTagName('input')[0].checked = true;
    });
    return newNode;
  };

  document.getElementById('update-image-binary').onclick = function() {
    return spexif.imageManager.writeImages();
  };

  document.getElementById('clear-select').onclick = function() {
    return spexif.imageManager.clearSelect();
  };

  document.getElementById('invert-select-image').onclick = function() {
    return spexif.imageManager.invertSelect();
  };

  document.getElementById('remove-select-image').onclick = function() {
    return spexif.imageManager.remove();
  };

  dateQueryFromServer = function(startDate, endDate, callback) {
    var addDate, queryArray;
    if (typeof callback !== 'function') {
      callback = function(responseDocument) {
        var i, img, len, ref, results;
        ref = responseDocument.getElementsByTagName('img');
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          img = ref[i];
          results.push(spexif.imageManager.addFromURL(img.src));
        }
        return results;
      };
    }
    queryArray = [];
    addDate = function(array, date, name) {
      if (date && date.valueOf()) {
        return array.push(name + '=' + date.toISOString().replace(/T.*$/, ''));
      }
    };
    queryArray.push('Type=Time');
    addDate(queryArray, startDate, 'DateFrom');
    addDate(queryArray, endDate, 'DateTo');
    return queryString;
  };

  dateEntries = {
    start: 'DateFrom',
    end: 'DateTo'
  };

  queryDateFromServer = function(startDate, endDate, url) {
    var addDate, queryArray, queryString, req;
    addDate = function(name, date, array) {
      if (date.valueOf()) {
        return array.push(name + '=' + date.toISOString().replace(/T.*$/, ''));
      }
    };
    queryArray = [];
    queryArray.push('Type=Time');
    addDate(dateEntries.start, startDate, queryArray);
    addDate(dateEntries.end, endDate, queryArray);
    queryString = '?' + queryArray.join('&');
    req = new XMLHttpRequest();
    req.responseType = 'document';
    req.open('GET', url + queryString);
    req.onload = function() {
      var i, img, len, ref, results;
      ref = this.response.getElementsByTagName('img');
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        img = ref[i];
        results.push(spexif.imageManager.addFromURL(img.src));
      }
      return results;
    };
    return req.send();
  };

  document.getElementById('query-select-image').onsubmit = function(evt) {
    var endDate, startDate;
    evt.preventDefault();
    startDate = new Date(this.elements[dateEntries.start].value);
    endDate = new Date(this.elements[dateEntries.end].value);
    switch (this.elements['query-from'].value) {
      case 'local':
        return spexif.imageManager.selectByDate(startDate, endDate);
      case 'server':
        return queryDateFromServer(startDate, endDate, this.action);
    }
  };

  spexif.domHelper = {
    createInfoNode: createInfoNode
  };

}).call(this);

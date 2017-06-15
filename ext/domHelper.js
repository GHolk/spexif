// Generated by CoffeeScript 1.12.1
(function() {
  var createInfoNode, template, updateExif;

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
    return spexif.imageManager.updatePoint(image);
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

  spexif.domHelper = {
    createInfoNode: createInfoNode
  };

}).call(this);

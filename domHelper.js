// Generated by CoffeeScript 1.12.1
(function() {
  var createInfoNode, getSelectedImages, imageManager, template;

  imageManager = spexif.imageManager;

  template = (function() {
    var node;
    node = document.getElementById('template').getElementsByClassName('image-template')[0].cloneNode(true);
    node.className = 'image-info';
    return node;
  })();

  createInfoNode = function(cacheImage) {
    var exif, newNode;
    newNode = template.cloneNode(true);
    newNode.cacheImage = cacheImage;
    newNode.getElementsByTagName('img')[0].src = cacheImage.thumbnailImage.url;
    exif = cacheImage.exif;
    newNode.getElementsByTagName('pre')[0].textContent = exif.date + "\n" + exif.maker + "\n" + exif.gps;
    return newNode;
  };

  getSelectedImages = function() {
    var checkbox, i, len, ref, results;
    ref = document.getElementsByTagName('input');
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      checkbox = ref[i];
      if (checkbox.checked) {
        results.push(checkbox.parentNode.cacheImage);
      }
    }
    return results;
  };

  spexif.domHelper = {
    createInfoNode: createInfoNode,
    getSelectedImages: getSelectedImages
  };

}).call(this);
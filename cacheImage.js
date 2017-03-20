// Generated by CoffeeScript 1.12.1
(function() {
  var CacheImage, FilterPiexif, Image64, imageList, myMap, speaker;

  myMap = spexif.myMap;

  speaker = spexif.speaker;

  imageList = spexif.imageList;

  FilterPiexif = spexif.FilterPiexif;

  Image64 = (function() {
    var createHTMLNode;

    function Image64(data) {
      if (data.slice(0, 23) === 'data:image/jpeg;base64,') {
        this.dataURL = data;
      } else if (data.match(/\W/)) {
        this.dataURL = 'data:image/jpeg;base64,' + btoa(data);
      } else {
        this.dataURL = 'data:image/jpeg;base64,' + data;
      }
    }

    createHTMLNode = function() {
      var image;
      image = document.createElement('img');
      image.src = this.dataURL;
      return image;
    };

    Image64.prototype.toString = function() {
      return this.dataURL;
    };

    Image64.prototype.toHTMLNode = function() {
      return this.HTMLNode || createHTMLNode.call(this);
    };

    return Image64;

  })();

  CacheImage = (function() {
    var createEXIF, createHTMLNode, createImage, createPoint;

    createEXIF = function(dataURL) {
      return new FilterPiexif(piexif.load(dataURL));
    };

    createImage = function(dataURL) {
      return new Image64(dataURL);
    };

    createPoint = function(image) {
      return myMap.createPoint(image);
    };

    function CacheImage(dataURL) {
      if (dataURL.slice(0, 23) !== 'data:image/jpeg;base64,') {
        speaker.errorFreindly('input is not jpeg file!');
        throw 'input is not jpeg file!' + '\n' + dataURL;
      }
      this.fullImage = createImage(dataURL);
      this.exif = createEXIF(dataURL);
      if (this.exif.thumbnail) {
        this.thumbnailImage = createImage(this.exif.thumbnail);
      }
      if (this.exif.gps) {
        this.mapPoint = createPoint(this);
      }
    }

    createHTMLNode = function() {
      var div, ref;
      div = document.createElement('div');
      div.className = 'image-info';
      div.appendChild(((ref = this.thumbnailImage) != null ? ref.toHTMLNode() : void 0) || this.fullImage.toHTMLNode());
      div.appendChild(this.exif.toHTMLNode());
      return div;
    };

    CacheImage.prototype.toHTMLNode = function() {
      return this.HTMLNode || (this.HTMLNode = createHTMLNode.call(this));
    };

    return CacheImage;

  })();

  spexif.CacheImage = CacheImage;

}).call(this);

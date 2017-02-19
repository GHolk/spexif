// Generated by CoffeeScript 1.12.1
(function() {
  var CacheImage, FilterPiexif, imageList, myMap, speaker;

  myMap = spexif.myMap;

  speaker = spexif.speaker;

  imageList = spexif.imageList;

  FilterPiexif = spexif.FilterPiexif;

  CacheImage = (function() {
    function CacheImage(dataURL) {
      if (dataURL.slice(0, 22) !== 'data:image/jpeg;base64') {
        speaker.errorFreindly('input is not jpeg file!');
        throw 'input is not jpeg file!';
      }
      this.dataURL = dataURL;
      this.createEXIF();
      this.createImageNode();
      this.createHTMLNode();
      if (this.exif.gps) {
        this.createPoint();
      }
      imageList.add(this);
    }

    CacheImage.prototype.createPoint = function() {
      return this.mapPoint = myMap.createPoint(this);
    };

    CacheImage.prototype.createImageNode = function() {
      var imageNode;
      imageNode = document.createElement('img');
      imageNode.src = this.dataURL;
      return this.imageNode = imageNode;
    };

    CacheImage.prototype.createHTMLNode = function() {
      return this.HTMLNode = this.exif.HTMLNode;
    };

    CacheImage.prototype.createEXIF = function() {
      var halfExif;
      halfExif = piexif.load(this.dataURL);
      return this.exif = new FilterPiexif(halfExif);
    };

    return CacheImage;

  })();

  spexif.CacheImage = CacheImage;

}).call(this);

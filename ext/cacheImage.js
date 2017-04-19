// Generated by CoffeeScript 1.12.1
(function() {
  var CacheImage, FilterPiexif, Image64, createInfoNode, myMap, speaker;

  myMap = spexif.myMap;

  speaker = spexif.speaker;

  FilterPiexif = spexif.FilterPiexif;

  createInfoNode = spexif.domHelper.createInfoNode;

  Image64 = (function() {
    function Image64(url, data) {
      if (url.slice(0, 23) === 'data:image/jpeg;base64,') {
        this.dataType = 'dataURL';
        this.url = url;
        this.data = atob(url.slice(23));
      } else if (data.slice(0, 2) === "\xff\xd8") {
        this.dataType = 'binaryString';
        this.url = url || 'data:image/jpeg;base64,' + btoa(data);
        this.data = data;
      } else {
        speaker.errorFriendly('input is not jpeg file!');
        throw 'input is not jpeg file!' + '\n' + data;
      }
    }

    Image64.prototype.toString = function() {
      return this.data;
    };

    return Image64;

  })();

  CacheImage = (function() {
    var createEXIF, createImage, createPoint;

    createEXIF = function(data) {
      return new FilterPiexif(piexif.load(data));
    };

    createImage = function(url, data) {
      return new Image64(url, data);
    };

    createPoint = function(image) {
      if (image.exif.gps.length === 2) {
        return myMap.createPoint(image);
      } else {
        return null;
      }
    };

    function CacheImage(url, data) {
      this.fullImage = createImage(url, data);
      this.exif = createEXIF(data);
      if (this.exif.thumbnail) {
        this.thumbnailImage = createImage('', this.exif.thumbnail);
      }
      this.updatePoint();
    }

    CacheImage.prototype.updatePoint = function() {
      return this.mapPoint = createPoint(this);
    };

    CacheImage.prototype.toHTMLNode = function() {
      return this.HTMLNode || (this.HTMLNode = createInfoNode(this));
    };

    return CacheImage;

  })();

  spexif.CacheImage = CacheImage;

}).call(this);

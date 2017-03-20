// Generated by CoffeeScript 1.12.1
(function() {
  var CacheImage, ImageList, myMap,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  myMap = spexif.myMap;

  CacheImage = spexif.CacheImage;

  ImageList = (function(superClass) {
    extend(ImageList, superClass);

    function ImageList() {
      this.map = myMap;
      this.asideNode = document.getElementById('image-container');
    }

    ImageList.prototype.add = function(dataURL) {
      var image;
      image = new CacheImage(dataURL);
      this.push(image);
      if (image.exif.gps) {
        return this.show(image);
      } else {
        return this.showAside(image);
      }
    };

    ImageList.prototype.show = function(image) {
      return this.map.showPoint(image);
    };

    ImageList.prototype.showAside = function(image) {
      return this.asideNode.appendChild(image.toHTMLNode());
    };

    ImageList.prototype.addFromURL = function(url) {
      var request;
      throw 'this function not work';
      request = new XMLHttpRequest();
      request.open('GET', url, true);
      request.responseType = 'arraybuffer';
      request.onreadystatechange = (function(_this) {
        return function() {
          var req, u8;
          req = request;
          if (req.readyState === 4 && req.status === 200) {
            u8 = new Uint8Array(req.response);
            return _this.add('data:image/jpeg;base64,' + btoa(String.fromCharCode.apply(_this, u8)));
          }
        };
      })(this);
      return request.send('');
    };

    return ImageList;

  })(Array);

  spexif.imageList = new ImageList();

}).call(this);

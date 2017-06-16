// Generated by CoffeeScript 1.12.1
(function() {
  var CacheImage, ImageManager, getSelectedImages, myMap;

  myMap = spexif.myMap;

  CacheImage = spexif.CacheImage;

  getSelectedImages = spexif.domHelper.getSelectedImages;

  ImageManager = (function() {
    var arrayBufferToBinaryString;

    ImageManager.prototype.add = function(cacheImage) {
      return this.list.push(cacheImage);
    };

    ImageManager.prototype.remove = function(cacheImage) {
      return this.list = this.list.filter(function(image) {
        return image !== cacheImage;
      });
    };

    function ImageManager() {
      this.list = [];
      this.map = myMap;
      this.asideNode = document.getElementById('image-container');
    }

    arrayBufferToBinaryString = function(arraybuffer) {
      var charCode, charCodeToChar, u8;
      u8 = new Uint8Array(arraybuffer);
      charCodeToChar = String.fromCharCode;
      return ((function() {
        var i, len, results;
        results = [];
        for (i = 0, len = u8.length; i < len; i++) {
          charCode = u8[i];
          results.push(charCodeToChar(charCode));
        }
        return results;
      })()).join('');
    };

    ImageManager.prototype.addFromBlob = function(blob) {
      var reader, theImageList, url, whenArrayBufferRead;
      url = URL.createObjectURL(blob);
      reader = new FileReader();
      theImageList = this;
      whenArrayBufferRead = function() {
        var image;
        image = new CacheImage(url, arrayBufferToBinaryString(this.result), blob);
        theImageList.add(image);
        return theImageList.show(image);
      };
      reader.onload = whenArrayBufferRead;
      return reader.readAsArrayBuffer(blob);
    };

    ImageManager.prototype.show = function(image) {
      if (image.mapPoint) {
        return this.showInMap(image);
      } else {
        return this.showAside(image);
      }
    };

    ImageManager.prototype.showInMap = function(image) {
      return this.map.showPoint(image);
    };

    ImageManager.prototype.showAside = function(image) {
      return this.asideNode.appendChild(image.toHTMLNode());
    };

    ImageManager.prototype.removeFromMap = function(image) {
      return this.map.removePoint(image);
    };

    ImageManager.prototype.updatePoint = function(image) {
      this.removeFromMap(image);
      image.updatePoint();
      return this.show(image);
    };

    ImageManager.prototype.addFromURL = function(url) {
      var addBlobImageToList, request;
      request = new XMLHttpRequest();
      request.open('GET', url, true);
      request.responseType = 'blob';
      addBlobImageToList = this.addFromBlob.bind(this);
      request.onload = function() {
        return addBlobImageToList(this.response);
      };
      return request.send('');
    };

    ImageManager.prototype.getChangedImages = function() {
      return this.list.filter(function(cacheImage) {
        return cacheImage.change;
      });
    };

    ImageManager.prototype.getSelectedImages = function() {
      return this.list.filter(function(cacheImage) {
        return cacheImage.select();
      });
    };

    ImageManager.prototype.writeImages = function(imageArray) {
      if (imageArray == null) {
        imageArray = this.getSelectedImages();
      }
      imageArray.forEach(function(image) {
        return image.updateImage();
      });
      return this.selectImages(imageArray);
    };

    ImageManager.prototype.selectImages = function(imageArray) {
      if (imageArray == null) {
        imageArray = this.list;
      }
      return imageArray.forEach(function(image) {
        return image.select(true);
      });
    };

    ImageManager.prototype.clearSelect = function(imageArray) {
      if (imageArray == null) {
        imageArray = this.list;
      }
      return imageArray.forEach(function(image) {
        return image.select(false);
      });
    };

    ImageManager.prototype.invertSelect = function(imageArray) {
      if (imageArray == null) {
        imageArray = this.list;
      }
      return imageArray.forEach(function(image) {
        var isCheck;
        isCheck = image.select();
        return image.select(!isCheck);
      });
    };

    ImageManager.prototype.selectByDate = function(startDate, endDate, selectMethod) {
      if (typeof selectMethod !== 'function') {
        selectMethod = function(image) {
          return image.select(true);
        };
      }
      return this.list.filter(function(image) {
        return !(image.exif.date < startDate) && !(image.exif.date > endDate);
      }).forEach(selectMethod);
    };

    ImageManager.prototype.queryDateFromServer = function(startDate, endDate, url) {
      var addDateStruct, addURLToList, queryArray, queryString, req;
      addDateStruct = function(struct, array) {
        if (struct) {
          struct.value = struct.value.toISOString().replace(/T.*$/, '');
        }
        return array.push(struct);
      };
      queryArray = [];
      queryArray.push({
        name: 'Type',
        value: 'Time'
      });
      addDateStruct(startDate, queryArray);
      addDateStruct(endDate, queryArray);
      queryString = '?' + queryArray.map(function(struct) {
        return struct.name + "=" + struct.value;
      }).join('&');
      req = new XMLHttpRequest();
      req.responseType = 'document';
      req.open('GET', url + queryString);
      addURLToList = this.addFromURL.bind(this);
      req.onload = function() {
        var i, img, imgs, len, results;
        imgs = this.response.getElementsByTagName('img');
        results = [];
        for (i = 0, len = imgs.length; i < len; i++) {
          img = imgs[i];
          results.push(addURLToList(img.src));
        }
        return results;
      };
      req.send();
      return window.req = req;
    };

    return ImageManager;

  })();

  spexif.imageManager = new ImageManager();

}).call(this);

// Generated by CoffeeScript 1.12.1
(function() {
  var FilterPiexif;

  FilterPiexif = (function() {
    function FilterPiexif(exif) {
      var err;
      try {
        this.date = this.getDate(exif.Exif);
      } catch (error) {
        err = error;
        speaker.error(err);
        speaker.errorFreindly("can't get date of photo. ");
      }
      try {
        this.maker = this.getMaker(exif['0th']);
      } catch (error) {
        err = error;
        speaker.error(err);
        speaker.errorFreindly("can't get camera of photo. ");
      }
      try {
        this.gps = [this.getGPS(exif.GPS, "GPSLongitude"), this.getGPS(exif.GPS, "GPSLatitude")];
      } catch (error) {
        err = error;
        speaker.error(err);
        speaker.errorFreindly("can't get gps data of photo. ");
      }
      try {
        this.thumbnailBase64 = btoa(exif.thumbnail);
      } catch (error) {
        err = error;
        speaker.error(err);
        speaker.errorFreindly("can't get thumbnail of photo. ");
      }
      this.createTextNode();
      this.createThumbnailNode();
      this.createHTMLNode();
    }

    FilterPiexif.prototype.getMaker = function(exif) {
      return exif[piexif.ImageIFD.Make].trim();
    };

    FilterPiexif.prototype.getDate = function(exif) {
      var date;
      date = exif[piexif.ExifIFD.DateTimeOriginal].split(' ');
      date[0] = date[0].replace(/:/g, '-');
      return date.join('T');
    };

    FilterPiexif.prototype.getGPS = function(exif, key) {
      var decimal, dms, i, len, part, ratio;
      dms = exif[piexif.GPSIFD[key]];
      ratio = 1;
      decimal = 0;
      for (i = 0, len = dms.length; i < len; i++) {
        part = dms[i];
        decimal += part[0] / part[1] / ratio;
        ratio *= 60;
      }
      return decimal;
    };

    FilterPiexif.prototype.createTextNode = function() {
      var textNode;
      textNode = document.createElement('pre');
      textNode.textContent = [this.date, this.maker, this.gps].join('\n');
      return this.textNode = textNode;
    };

    FilterPiexif.prototype.createThumbnailNode = function() {
      var imageNode;
      imageNode = document.createElement('img');
      imageNode.src = 'data:' + 'image/jpeg;' + 'base64,' + this.thumbnailBase64;
      return this.imageNode = imageNode;
    };

    FilterPiexif.prototype.createHTMLNode = function() {
      var HTMLNode;
      HTMLNode = document.createElement('div');
      HTMLNode.appendChild(this.imageNode);
      HTMLNode.appendChild(this.textNode);
      return this.HTMLNode = HTMLNode;
    };

    return FilterPiexif;

  })();

  spexif.FilterPiexif = FilterPiexif;

}).call(this);
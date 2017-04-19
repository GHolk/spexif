// Generated by CoffeeScript 1.12.1
(function() {
  var FilterPiexif, speaker;

  speaker = spexif.speaker;

  FilterPiexif = (function() {
    var createHTMLNode, get, set;

    get = {
      maker: function(exif) {
        return exif['0th'][piexif.ImageIFD.Make].trim();
      },
      date: function(exif) {
        return exif.Exif[piexif.ExifIFD.DateTimeOriginal];
      },
      oneOfGPS: function(exif, key) {
        var decimal, dms, ratio;
        dms = exif.GPS[piexif.GPSIFD[key]];
        ratio = 1;
        decimal = 0;
        return dms.map(function(part) {
          return part[0] / part[1];
        }).reduce((function(sum, hex, i) {
          return sum + hex / (Math.pow(60, i));
        }), 0);
      },
      gps: function(exif) {
        return ['GPSLongitude', 'GPSLatitude'].map((function(_this) {
          return function(key) {
            return _this.oneOfGPS(exif, key);
          };
        })(this));
      }
    };

    set = {
      maker: function(exif, maker) {
        return exif['0th'][piexif.ImageIFD.Make] = maker;
      },
      date: function(exif, date) {
        return exif.Exif[piexif.ExifIFD.DateTimeOriginal] = date;
      },
      oneOfGPS: function(exif, key, dmsText) {
        var toFrac, toInt;
        toInt = function(f) {
          return Math.floor(f);
        };
        toFrac = function(f, i) {
          return [toInt(f * i), i];
        };
        return exif.GPS[piexif.GPSIFD[key]] = (function(dmsText) {
          var float;
          float = Number(dmsText);
          return [float, float * 60 % 60, float * 60 * 60 % 60].map(function(fa) {
            return [toFrac(fa[0], 1), toFrac(fa[1], 1), toFrac(fa[2], 10000)];
          });
        })(dmsText);
      },
      gps: function(exif, dms) {
        if (typeof dms === 'string') {
          dms = dms.split(',');
        }
        return ['GPSLongitude', 'GPSLatitude'].forEach(function(key, i) {
          return set.oneOfGPS(exif, key, dms[i]);
        });
      }
    };

    FilterPiexif.prototype.gps = [];

    function FilterPiexif(allExif) {
      var err, j, key, len, ref;
      this.allExif = allExif;
      ref = ['date', 'maker', 'gps'];
      for (j = 0, len = ref.length; j < len; j++) {
        key = ref[j];
        try {
          this[key] = get[key](allExif);
        } catch (error) {
          err = error;
          speaker.error(err);
          speaker.errorFriendly("can't get " + key + " of photo. ");
        }
      }
      try {
        if (!(this.thumbnail = allExif.thumbnail)) {
          throw allExif.thumbnail;
        }
      } catch (error) {
        err = error;
        speaker.error(err);
        speaker.errorFriendly("can't get thumbnail of photo. ");
      }
    }

    FilterPiexif.prototype.update = function() {
      var err, j, key, len, ref, results;
      ref = ['date', 'maker', 'gps'];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        key = ref[j];
        try {
          results.push(set[key](this.allExif, this[key]));
        } catch (error) {
          err = error;
          speaker.error(err);
          results.push(speaker.errorFriendly("can't set " + key + " of photo. "));
        }
      }
      return results;
    };

    createHTMLNode = function() {
      var preNode;
      preNode = document.createElement('pre');
      preNode.textContent = [this.date, this.maker, this.gps].join('\n');
      return preNode;
    };

    FilterPiexif.prototype.toHTMLNode = function() {
      return this.HTMLNode || (this.HTMLNode = createHTMLNode.call(this));
    };

    return FilterPiexif;

  })();

  spexif.FilterPiexif = FilterPiexif;

}).call(this);

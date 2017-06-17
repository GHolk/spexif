// Generated by CoffeeScript 1.12.1
(function() {
  var CacheImage, fileForm, imageManager, speaker, whenInputFiles;

  CacheImage = spexif.CacheImage;

  imageManager = spexif.imageManager;

  speaker = spexif.speaker;

  whenInputFiles = function(evt) {
    var file, files, i, len, results;
    files = evt.target.files;
    results = [];
    for (i = 0, len = files.length; i < len; i++) {
      file = files[i];
      results.push(imageManager.addFromBlob(file));
    }
    return results;
  };

  fileForm = document.getElementById('load-image');

  fileForm.elements[0].addEventListener('change', whenInputFiles, true);

  fileForm.addEventListener('submit', function(evt) {
    var fileEntry, formData, i, image, imageList, len, xmlRequest;
    evt.preventDefault();
    fileEntry = this.elements[0].name;
    imageList = spexif.imageManager.getSelectedImages();
    if (imageList.length > 0) {
      formData = new FormData(this);
      formData["delete"](fileEntry);
      for (i = 0, len = imageList.length; i < len; i++) {
        image = imageList[i];
        formData.append(fileEntry, image.fullImage.blob);
      }
      xmlRequest = new XMLHttpRequest();
      xmlRequest.open(this.method.toUpperCase(), this.action);
      xmlRequest.onload = function() {
        var j, len1, results;
        speaker.logFriendly('successful upload selected image.');
        results = [];
        for (j = 0, len1 = imageList.length; j < len1; j++) {
          image = imageList[j];
          results.push(imageManager.changeImageNameInServer.push(image.fullImage.blob.name));
        }
        return results;
      };
      xmlRequest.onerror = function() {
        return speaker.errorFriendly(new Error('can not upload selected image!'));
      };
      return xmlRequest.send(formData);
    } else {
      return speaker.errorFriendly('no image selected.');
    }
  });

}).call(this);

// Credit: http://www.kylejlarson.com/blog/2012/creating-retina-images-for-your-website/
$(function () {
	if (window.devicePixelRatio == 2) {
          var images = $("img.hidef");

          // loop through the images and make them hi-res
          for(var i = 0; i < images.length; i++) {

            // create new image name
            var imageType = images[i].src.substr(-4);
            var imageName = images[i].src.substr(0, images[i].src.length - 4);
            imageName += "@2x" + imageType;

            //rename image
            images[i].src = imageName;
          }
     }
});
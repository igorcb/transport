$.fn.imagePreview = function(container) {
    $(this).on('change', function () {
	    if (typeof (FileReader) != "undefined") {

		var image_holder = $(container);
		image_holder.empty();

		var reader = new FileReader();
		reader.onload = function (e) {
      console.log(e.target.result);
		    $("<img />", {
			"src": e.target.result,
			"class": "thumb-image"
		    }).appendTo(image_holder);
		}
		image_holder.show();
		reader.readAsDataURL($(this)[0].files[0]);
	    } else{
		alert("Este navegador nao suporta FileReader.");
	    }
	});
};

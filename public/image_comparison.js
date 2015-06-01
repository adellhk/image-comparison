var server = 'http://localhost:9393/';
imgSelections = [];

$(document).ready(function() {
	bindImageListeners();
	bindCompareButton();
});

function bindImageListeners() {
	$('.uploaded-image').on('click', function(event) {
		event.preventDefault();
		$(this).addClass('selected');
		imgSelections.push($(this).attr('src'));
	});
}

function bindCompareButton() {
	$('#compareButton').on('click', function(event) {
		event.preventDefault();
		payload = {
			first_image: imgSelections[imgSelections.length-1],
			second_image: imgSelections[imgSelections.length-2]
		};
		$.ajax({
			url: server+'compare_images',
			type: 'POST',
			dataType: 'JSON',
			data: payload,
		})
		.done(function() {
			console.log("success");
		})
		.fail(function(serverData) {
			console.log("error");
		})
		.always(function() {
			console.log("complete");
			location.reload();
		});
		
	});
}
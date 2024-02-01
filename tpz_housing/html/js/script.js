

// When loading for first time, we hide the UI for avoiding any displaying issues.
document.addEventListener('DOMContentLoaded', function() {
	$('#housing').hide();
}, false);


$(function() {

	window.addEventListener('message', function(event) {
		var item = event.data;

		if (item.type == "enable") {
			item.enable ? $('#housing').fadeIn() : $('#housing').fadeOut();
		}

		else if (item.action == "updateCurrentSelectedType"){

			document.getElementById("current_selected_image_display").style.backgroundImage = `url(img/` + item.backgroundImageUrl + `)`;
		}

		else if (item.action == 'closeUI'){
			closeNUI();
		}
		

	});

	
});

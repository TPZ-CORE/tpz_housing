
function load(src) {
	return new Promise((resolve, reject) => {
		const image = new Image();
		image.addEventListener('load', resolve);
		image.addEventListener('error', reject);
		image.src = src;
	});
}

function closeNUI() {

	$('#housing').fadeOut();

	document.getElementById("current_selected_image_display").style.backgroundImage = null;
    $.post("http://tpz_housing/closeNUI", JSON.stringify({ }));
}

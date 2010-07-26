template = '<a href="http://www.srlfacile.org">\n<img border="0" src="/images/REPLACEME.jpg" alt="SrlFacile Banner"\ntitle="Firma la petizione contro SrL eccessivamente costose e burocratiche"></img>\n</a>';

$(document).ready(function(){
    $('.bannerimage').click(function() {
	$('#bannercode').val(template.replace("REPLACEME", this.id));
	$('.bannerimage').css('border', '0');
	$(this).css('border', '2px dashed gray');
    });
    $('#half_banner_234x60px').click();
});
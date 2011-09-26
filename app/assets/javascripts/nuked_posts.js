jQuery(document).ready(function() {
  jQuery('.post-nuked-show a').live('click', function(e) {
    e.preventDefault();

    temp = jQuery(this).closest('.post-nuked-show')
    temp.siblings('.post-nuked').show();
    temp.hide();
  });
});

jQuery(document).ready(function() {
  jQuery('.vote-enabled').live('ajax:complete', function(evt, data) {
    jQuery('.vote-count', this).html(data.responseText)
  });
});

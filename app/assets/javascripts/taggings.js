jQuery('#taggings .remove').bind('ajax:complete', function(event, xhr, status){
  eval(xhr.responseText);
});
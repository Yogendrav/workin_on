// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.maskedinput
//= require locationpicker.jquery
//= require fullcalendar
//= require worker-calendar
//= require fancybox/jquery.mousewheel-3.0.6.pack.js
//= require fancybox/jquery.fancybox.pack.js
//= require fancybox/jquery.fancybox-buttons.js
//= require fancybox/jquery.fancybox-media.js
//= require fancybox/jquery.fancybox-thumbs.js
//= require_tree .


$(document).ready(function(){
  
  // Show selected image url in input box
  $(document).on('change', ':file', function(event) {
    $("#profile_photo_path").val($(event.currentTarget).val().replace(/\\/g, '/').replace(/.*\//, ''));
  });

  // After selecting image, show image preview
  $(document).on('click', '#upload_photo_btn', function() {
    var input = $("#profile_photo");
    var file = input[0].files[0];
    var reader = new FileReader();
    reader.onload = function(e){
        image_base64 = e.target.result;
        $(".upload-preview img").attr("src", image_base64);
    };
    reader.readAsDataURL(file);
  });

  $(document).on('click', '.go-top', function(){
    $('html, body').animate({scrollTop : 0},500);
    return false;
  })

  // Masking in phone field
  $("#admin_phone, #worker_phone").mask("(999) 999-9999");
  
  // Show time picker
  $('.timepicker').timepicker();

  $(".select2-drop-down").select2();
  
  // teams activity show by default data day wise
  $("#activity_day, #project_activity_day").click();
});

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .
//= require_self

  $(function() {
    $('#my-menu').mmenu({
      extensions  : [ 'effect-slide-menu', "border-full", "pageshadow" ],
      counters  : true,
      navbar    : {
        title : null,
        content : ['next', 'previous', 'title']
      }
    });
  });

$(document).ready(function() {

  var API = $("#my-menu").data( "mmenu" );
  $("#my-button").click(function() {
    API.open();
  });


  $("#flip").click(function(){
      $("#panel").slideToggle("fast");
  });

  $("#gflip").click(function(){
      $("#gpanel").slideToggle("fast");
  });

   
  $("tr[data-link]").click(function() {
    window.location = this.dataset.link
  });


  $(function () {
    $('[data-toggle="popover"]').popover()
  });

// ------------------- make selected categories orange ---------------------------------------------
    $('input[type=checkbox]:checked').each(function() {
        $('a#' + this.id).css("background-color", "orange");
        if ($('a#' + this.id).hasClass('gategory-head-checkbox')) {
          $('a#' + this.id + '.gategory-head-checkbox').css("background-color", "#5CB85C");
        }
    });


// ------------------------------------------------------------------
  $("a.check-enabled").click(function(){

      if ($('input#' + $(this).attr('id')).prop('checked') == false) {
        $('input#' + $(this).attr('id')).prop('checked', true);
        $(this).css("background-color", "orange");
      } else {
        $('input#' + $(this).attr('id')).prop('checked', false);
        $(this).css("background-color", "#458FFF");
      }
  });

    $("a.gcheck-enabled").click(function(){

      if ($('input#' + $(this).attr('id')).prop('checked') == false) {
        $('input#' + $(this).attr('id')).prop('checked', true);
        $(this).css("background-color", "orange");
      } else {
        $('input#' + $(this).attr('id')).prop('checked', false);
        $(this).css("background-color", "#339933");
      }
  });
// ----------------------------------- --------------------------------

  $("a.category-head-checkbox").click(function(){

      if ($('a#' + $(this).attr('id')).hasClass('collapsed')) {
        $('input#' + $(this).attr('id')).prop('checked', true);
        $(this).css("background-color", "orange");
        $('a#' + $(this).attr('id')).removeClass('collapsed');

      } else {
        $('input#' + $(this).attr('id')).prop('checked', false);
        $(this).css("background-color", "#458FFF");
      }
  });

  $("a.gategory-head-checkbox").click(function(){

      if ($('input#' + $(this).attr('id')).prop('checked') == false) {
        $('input#' + $(this).attr('id')).prop('checked', true);
        $('a#' + $(this).attr('id')).css("background-color", "orange");
        $(this).css("background-color", "green");
      } 
  });


});





$(window).load(function () {
    $('.flexslider').flexslider();
});


$(document).ready(function(){
  $('#occupants_list').dataTable();
  $('#rooms_list').dataTable();
  $('#utilities_list').dataTable();
  $('#billings').dataTable({
      "order": [[0, "desc"]]
  });

  $('#datepicker').datepicker({
    changeMonth: true,
    changeYear: true
  });
  $('#datepicker2').datepicker({
    changeMonth: true,
    changeYear: true
  });
});

$(function () {
    $('#work').carouFredSel({
        width: '100%',
        scroll: 1,
        auto: false,
        pagination: false,
        prev: '.prev_item',
        next: '.next_item'
    });

    $("#work").touchwipe({
        wipeLeft: function () { $('.next_item').trigger('click'); },
        wipeRight: function () { $('.prev_item').trigger('click'); }
    });
});

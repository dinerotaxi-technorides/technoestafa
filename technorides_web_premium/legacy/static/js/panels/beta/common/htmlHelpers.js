// Tr
function tr(trClass, trId, trRel, trContentArray) {
  // Tr Content
  trContent = "";

  // Tds
  $.each(
    trContentArray,
    function(index, td) {
      trContent += td;
    }
  );
  return "<tr id='" + trId + "' rel='" + trRel + " 'class='" + trClass + "'>" + trContent + "</tr>";
}

// Td
function td(tdClass, tdContent) {
  return "<td class='" + tdClass + "'>" + tdContent + "</td>";
}

// Img
function img(imageSrc) {
  return "<img src='/static/images/panels/operator/" + imageSrc + "'/>";
}

// Sort Select
$.fn.sort_select_box = function() {
  var my_options = $("#" + this.attr('id') + ' option');
  my_options.sort(
    function(a,b) {
      if(a.text > b.text) return 1;
      else if (a.text < b.text) return -1;
      else return 0
    }
  );
  $(this).html(my_options);

  return my_options;
}

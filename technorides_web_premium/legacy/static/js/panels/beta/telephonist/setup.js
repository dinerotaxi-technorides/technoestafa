// Advanced || Basic?
$("#toggle_mode").button();

splittedPathname = window.location.pathname.split("/");
is_beta  = splittedPathname[splittedPathname.length - 1] == "beta";

$("#toggle_mode").click(function() {
  $.cookie("use_beta", !is_beta + "", {"path": "/"});
  console.log("Redirecting...");
  window.location = $(this).attr("rel");

  return false;
});

//if($.cookie("use_beta") != undefined && is_beta + "" != $.cookie("use_beta")) {
//  console.log("Wrong mode! Beta? Current: " + is_beta + " Right: " + $.cookie("use_beta"));
//  $("#toggle_mode").click();
//}

// Toggle
$(document).on("click", ".toggle",
  function() {
    rel = $($(this).attr("rel"));
    rel.toggle();
    newText = rel.is(":visible") ? "-" : "+";
    $(this).text(newText);
  }
);

$(".toggle").click();

$(".hidden").hide();

// Button
$(".button").button();


// New Operation
$("#new_operation_link").click(
  function() {
    $("#new_operation_dialog").dialog("open");
    $("#new_operation_address_from_city").val(city_user);
  }
);

// Error
$("#api_connection_error_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Dialog Close
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playErrorSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// New Operation
$("#new_operation_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    width    : "470px",
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          if(($("#new_operation_phone_number").val().length > 0) && ($("#new_operation_email").val().length > 0) && ($("#new_operation_name").val().length > 0) && ($("#new_operation_surname").val().length > 0) && ($("#new_operation_address_from_city").val().length > 0) && ($("#new_operation_address_from_street").val().length > 0) && ($("#new_operation_address_from_street_number").val().length > 0) && validateEmail($("#new_operation_email").val()) && (($("#new_operation_driver_number").val().length == 0) || (parseInt($("#new_operation_driver_number").val()) > 0))) {
            // Create Operation
            createOperation();

            // Scheduled
            panel.api.getScheduledOperations();

            // Sound
            playSuccessSound();

            // Clear
            clearForm();

            // Dialog Close
            $(this).dialog("close");
          } else {
            $("#form_error_dialog").dialog("open");
          }
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          // Dialog
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playAnswerSound();
    },
    close: function() {
      // Clear form field
      clearForm();
      // Sound
      playSuccessSound();
    }
  }
);

$("#new_operation_dialog #new_operation_phone_number").autocomplete({
    source: function(request, response) {
      $.ajax(
        {
          url     : panel.api.USERS_URL,
          dataType: "json",
          data    : {
            type : "phone",
            token: panel.api.token,
            term : request.term
          },
          success : function(data) {
            response(data.rows);
          }
        }
      )
    },
    minLength: 4,
    select   : function(event, ui) {
      $("#new_operation_phone_number").val(ui.item.phone);
      $("#new_operation_email").val(ui.item.email);
      $("#new_operation_name").val(ui.item.first_name);
      $("#new_operation_surname").val(ui.item.last_name);
      $("#new_operation_id").val(ui.item.user_id);
      panel.api.getHistory(ui.item.user_id);
      return false;
    }
  }
);

$("#new_operation_dialog #new_operation_address_from").autocomplete({
    source: function (request, response) {

      $(".address_from input[type=hidden]").val("");

      address_from_geocode(false, function(places) {
        out = [];
        for (var i in places) {
          out.push(places[i].formatted_address);
        }
        response(out);

        fill_address_from_form_autocomplete_result_based(places[0]);
      });
    },

    select: function(event, ui) {
      address_from_geocode(false, function(places) {
        fill_address_from_form_autocomplete_result_based(places[0]);
      },
      ui.item.label);
    },
  }
);

$(".address_from input:not(#new_operation_address_from):not(#new_operation_address_from_floor):not(#new_operation_address_from_apartment)").bind("keyup",
  function() {
    address_from_geocode_old(false);
  }
);


function address_to_geocode_to() {
  result = panel.api.geocode($("#new_operation_address_to_country").val(), $("#new_operation_address_to_city").val(), $("#new_operation_address_to_street").val(), $("#new_operation_address_to_street_number").val(),
    function(position) {
      $("#new_operation_address_to_latitude").val(position.lat());
      $("#new_operation_address_to_longitude").val(position.lng());

      panel.map.panTo(position.lat(), position.lng());
      panel.map.setZoom(18);
      panel.map.addDraggableMarker("new_operation_address_to", position.lat(), position.lng(), "/static/images/panels/telephonist/new_operation/address_to.png", I18n.panels.telephonist.address_to, "",
        function(position) {
          $("#new_operation_address_to_latitude").val(position.lat());
          $("#new_operation_address_to_longitude").val(position.lng());
        }
      );
    }
  );
}
$(".address_to input:not(#new_operation_address_to):not(#new_operation_address_to_floor):not(#new_operation_address_to_apartment)").bind("keyup",
  function() {
    address_to_geocode_to();
  }
);



function fill_address_from_form_autocomplete_result_based(place) {
  for(i in place.address_components) {
    switch(place.address_components[i].types[0]) {
      case "street_number":
        $("#new_operation_address_from_street_number").val(place.address_components[i].long_name);
        break;
      case "route":
        $("#new_operation_address_from_street").val(place.address_components[i].long_name);
        break;
      case "locality":
        $("#new_operation_address_from_city").val(place.address_components[i].long_name);
        break;
      case "country":
        $("#new_operation_address_from_country").val(place.address_components[i].long_name);
        break;
    }
  }
}

$("#new_operation_dialog #new_operation_address_to").autocomplete({
    source: function (request, response) {

      $(".address_to input[type=hidden]").val("");

      address_to_geocode(false, function(places) {
        out = [];
        for (var i in places) {
          out.push(places[i].formatted_address);
        }
        response(out);

        fill_address_to_form_autocomplete_result_based(places[0]);
      });
    },

    select: function(event, ui) {
      address_to_geocode(false, function(places) {
        fill_address_to_form_autocomplete_result_based(places[0]);
      },
      ui.item.label);
    },
  }
);

function fill_address_to_form_autocomplete_result_based(place) {
  for(i in place.address_components) {
    switch(place.address_components[i].types[0]) {
      case "street_number":
        $("#new_operation_address_to_street_number").val(place.address_components[i].long_name);
        break;
      case "route":
        $("#new_operation_address_to_street").val(place.address_components[i].long_name);
        break;
      case "locality":
        $("#new_operation_address_to_city").val(place.address_components[i].long_name);
        break;
      case "country":
        $("#new_operation_address_to_country").val(place.address_components[i].long_name);
        break;
    }
  }
}


$("#new_operation_dialog #new_operation_email").autocomplete(
  {
    source: function(request, response) {
      $.ajax(
        {
          url     : panel.api.USERS_URL,
          dataType: "json",
          data    : {
            type : "email",
            token: panel.api.token,
            term : request.term
          },
          success : function(data) {
            response(data.rows);
          }
        }
      );
    },
    minLength: 4,
    select   : function(event, ui) {
      $("#new_operation_phone_number").val(ui.item.phone);
      $("#new_operation_email").val(ui.item.email);
      $("#new_operation_name").val(ui.item.first_name);
      $("#new_operation_surname").val(ui.item.last_name);
      $("#new_operation_id").val(ui.item.user_id);
      panel.api.getHistory(ui.item.user_id);
      return false;
    }
  }
);

// Create Operation
function createOperation() {
  var driverNumber = parseInt($("#new_operation_driver_number").val());
  if(isNaN(driverNumber))
    driverNumber = undefined;

  panel.api.createOperation(
    {
      user        : {
        id          : $("#new_operation_id").val(),
        phone_number: $("#new_operation_phone_number").val(),
        email       : $("#new_operation_email").val().trim(),
        name        : $("#new_operation_name").val(),
        surname     : $("#new_operation_surname").val(),
      },

      country     : panel.api.defaultCountry,
      ccode       : panel.api.defaultCcode,

      address_from: {
        country      : $("#new_operation_address_from_country").val(),
        city         : $("#new_operation_address_from_city").val(),
        street       : $("#new_operation_address_from_street").val(),
        street_number: $("#new_operation_address_from_street_number").val(),
        floor        : $("#new_operation_address_from_floor").val(),
        apartment    : $("#new_operation_address_from_apartment").val(),
        latitude     : $("#new_operation_address_from_latitude").val(),
        longitude    : $("#new_operation_address_from_longitude").val(),
      },

      address_to  : {
        country      : $("#new_operation_address_to_country").val(),
        city         : $("#new_operation_address_to_city").val(),
        street       : $("#new_operation_address_to_street").val(),
        street_number: $("#new_operation_address_to_street_number").val(),
        floor        : $("#new_operation_address_to_floor").val(),
        apartment    : $("#new_operation_address_to_apartment").val(),
        latitude     : $("#new_operation_address_to_latitude").val(),
        longitude    : $("#new_operation_address_to_longitude").val(),
      },

      driver_number: driverNumber,

      date         : $("#new_operation_date").datepicker("getDate"),
      time         : $("#new_operation_time").val(),

      comments     : $("#new_operation_comments").val(),

      options      : {
        messaging        : $("#new_operation_options_messaging").is(":checked"),
        pet              : $("#new_operation_options_pet").is(":checked"),
        air_conditioning : $("#new_operation_options_air_conditioning").is(":checked"),
        smoker           : $("#new_operation_options_smoker").is(":checked"),
        special_assistant: $("#new_operation_options_special_assistant").is(":checked"),
        luggage          : $("#new_operation_options_luggage").is(":checked"),
        vip              : $("#new_operation_options_vip").is(":checked"),
        airport          : $("#new_operation_options_airport").is(":checked"),
        invoice          : $("#new_operation_options_invoice").is(":checked")
      }
    }
  );
}

// Clear form fields
function clearForm() {
  $("#new_operation_form input").val("");
  $("#new_operation_form textarea").val("");
  $("#new_operation_form input[type=checkbox]").attr("checked", false);

  // Favorites
  $(".favorites ul li").remove();
  $(".toggle:contains(-)").click();

  // Clear markers
  if(panel.map.markers["new_operation_address_from"] != undefined) {
    panel.map.markers["new_operation_address_from"].marker.setMap(null);
    panel.map.markers["new_operation_address_from"] = undefined;
  }

  if(panel.map.markers["new_operation_address_to"] != undefined) {
    panel.map.markers["new_operation_address_to"].marker.setMap(null);
    panel.map.markers["new_operation_address_to"] = undefined;
  }
}

// DatePicker
jQuery(function($) {
  $.datepicker.setDefaults($.datepicker.regional[language]);
  $("#new_operation_date").datepicker(
    {
      option : $.datepicker.regional[language],
      minDate: 0
    }
  );
});

// TimePicker
$("#new_operation_time").timepicker(
  {
    hourText  : I18n.panels.telephonist.hour,
    minuteText: I18n.panels.telephonist.minutes
  }
);

// Favorites
$(document).on("click", "li.favorites_link",
  function() {
    json = JSON.parse($(this).attr("rel"));

    $("#new_operation_address_from_country").val(json.country);
    $("#new_operation_address_from_city").val(json.locality);

    $("#new_operation_address_from_street").val(json.street);
    $("#new_operation_address_from_street_number").val(json.street_number);

    $("#new_operation_address_from_floor").val(json.floor);
    $("#new_operation_address_from_apartment").val(json.department);

    $("#new_operation_address_from_latitude").val(json.lat);
    $("#new_operation_address_from_longitude").val(json.lng);

    $("#new_operation_address_from").val(json.country + ", " + json.locality + ", " + json.street);

    if(json.comments != null) {
      $("#new_operation_comments").val(json.comments);
      if($(".comments:visible").length == 0)
        $(".toggle[rel='.comments']").click();
    } else {
      $("#new_operation_comments").val("");
    }

    $(".toggle[rel='.favorites']").click();

    address_from_geocode(true);
  }
);

// Geocode
function address_from_geocode(should_use_latitude_and_longitude, action, autocomplete_address) {
  // Favorites
  if(should_use_latitude_and_longitude) {
    
    latitude = $("#new_operation_address_from_latitude").val();
    longitude = $("#new_operation_address_from_longitude").val();

    panel.map.panTo(latitude, longitude);
    panel.map.setZoom(18);
    panel.map.addDraggableMarker("new_operation_address_from", latitude, longitude, "/static/images/panels/telephonist/new_operation/address_from.png", I18n.panels.telephonist.address_from, "",
      function(position) {
        $("#new_operation_address_from_latitude").val(position.lat());
        $("#new_operation_address_from_longitude").val(position.lng());
      }
    );
  } else {
    // Autocomplete result click
    autocomplete_address  = autocomplete_address || $("#new_operation_address_from").val();
    console.log("Moving map to address from: " + autocomplete_address);

    result = panel.api.geocode_autocompleter(autocomplete_address,
      function(position, raw_data) {
        $("#new_operation_address_from_latitude").val(position.lat());
        $("#new_operation_address_from_longitude").val(position.lng());
        if (action != undefined){
          action(raw_data);
        }

        panel.map.panTo(position.lat(), position.lng());
        panel.map.setZoom(18);
        panel.map.addDraggableMarker("new_operation_address_from", position.lat(), position.lng(), "/static/images/panels/telephonist/new_operation/address_from.png", I18n.panels.telephonist.address_from, "",
          function(position) {
            $("#new_operation_address_from_latitude").val(position.lat());
            $("#new_operation_address_from_longitude").val(position.lng());
          }
        );
      }
    );
  }

  calculatePrice();
}

function address_from_geocode_old(should_use_latitude_and_longitude) {
  // Favorites
  if(should_use_latitude_and_longitude) {
    latitude = $("#new_operation_address_from_latitude").val();
    longitude = $("#new_operation_address_from_longitude").val();

    panel.map.panTo(latitude, longitude);
    panel.map.setZoom(18);
    panel.map.addDraggableMarker("new_operation_address_from", latitude, longitude, "/static/images/panels/telephonist/new_operation/address_from.png", I18n.panels.telephonist.address_from, "",
      function(position) {
        $("#new_operation_address_from_latitude").val(position.lat());
        $("#new_operation_address_from_longitude").val(position.lng());
      }
    );
  } else {
    result = panel.api.geocode($("#new_operation_address_from_country").val(), $("#new_operation_address_from_city").val(), $("#new_operation_address_from_street").val(), $("#new_operation_address_from_street_number").val(),
      function(position) {
        $("#new_operation_address_from_latitude").val(position.lat());
        $("#new_operation_address_from_longitude").val(position.lng());

        panel.map.panTo(position.lat(), position.lng());
        panel.map.setZoom(18);
        panel.map.addDraggableMarker("new_operation_address_from", position.lat(), position.lng(), "/static/images/panels/telephonist/new_operation/address_from.png", I18n.panels.telephonist.address_from, "",
          function(position) {
            $("#new_operation_address_from_latitude").val(position.lat());
            $("#new_operation_address_from_longitude").val(position.lng());
          }
        );
      }
    );
  }
}





$("input#new_operation_address_from_street_number").bind("keyup",
  function() {
    // Using street number
    address_from_geocode(false, function(){}, $("#new_operation_address_from_street").val() + " " + $("#new_operation_address_from_street_number").val() + ", " + $("#new_operation_address_from_city").val() + ", " + $("#new_operation_address_from_country").val());
  }
);

function address_to_geocode(autocomplete_address, action) {
  // Autocomplete result click
  autocomplete_address = autocomplete_address || $("#new_operation_address_to").val();
  console.log("Moving map to address to: " + autocomplete_address);

  result = panel.api.geocode_autocompleter(autocomplete_address,
    function(position, raw_data) {
      $("#new_operation_address_to_latitude").val(position.lat());
      $("#new_operation_address_to_longitude").val(position.lng());
      if (action != undefined){
        action(raw_data);
      }

      panel.map.panTo(position.lat(), position.lng());
      panel.map.setZoom(18);
      panel.map.addDraggableMarker("new_operation_address_to", position.lat(), position.lng(), "/static/images/panels/telephonist/new_operation/address_to.png", I18n.panels.telephonist.address_to, "",
        function(position) {
          $("#new_operation_address_to_latitude").val(position.lat());
          $("#new_operation_address_to_longitude").val(position.lng());
        }
      );
    }
  );

  calculatePrice();
}

$("input#new_operation_address_to_street_number").bind("keyup",
  function() {
    // Using street number
    address_to_geocode($("#new_operation_address_to_street").val() + " " + $("#new_operation_address_to_street_number").val() + ", " + $("#new_operation_address_to_city").val() + ", " + $("#new_operation_address_to_country").val(), function(){});
  }
);

function calculatePrice() {
  var addressFrom = [$("#new_operation_address_from_latitude").val(), $("#new_operation_address_from_longitude").val()];
  var addressTo   = [$("#new_operation_address_to_latitude").val(), $("#new_operation_address_to_longitude").val()];

  if(addressFrom.indexOf("") == -1 && addressTo.indexOf("") == -1)
    panel.api.getPrice(addressFrom, addressTo);
}

company   = new Company(
  {
    id       : companyId,
    email    : companyEmail,
    rtaxi    : companyRtaxi,
    name     : companyName,
    domain   : companyDomain,
    latitude : companyLatitude,
    longitude: companyLongitude,
    timezone : companyTimezone
  }
);
map       = new Map(
  {
    id        : "map_canvas",
    latitude  : company.latitude,
    longitude : company.longitude,
    zoom      : 14,
    hideLabels: false
  }
);
var panel = new Panel(
  {
    company: company,
    map    : map
  }
);
panel.api = new Api(
  {
    baseUrl       : apiBaseUrl,
    reloginUrl    : apiReloginUrl,
    token         : apiToken,
    maxFavorites  : maxFavorites,
    defaultCountry: defaultCountry,
    defaultCcode  : defaultCcode,
    handler       : new TelephonistApiHandler()
  }
);
webSocketConnection = new WebSocketConnection(
  {
    host    : webSocketServerHost,
    port    : webSocketServerPort,
    panel   : panel,
    handler : new WebSocketHandler(),
    userType: "company"
  }
);

// Get Scheduled
setInterval(function(){panel.api.getScheduledOperations()}, 30000);

// Marker
panel.addMarker();

// Parkings
panel.api.getParkings();

// flowplayer("player", "/static/js/panels/company/flowplayer/flowplayer-3.2.18.swf", {clip: {autoPlay: false}});

// Tutorial
$("#tutorial_dialog").dialog(
  {
    autoOpen : false,
    resizable: false,
    width    : "1145px",
    buttons  : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Dialog Close
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playSuccessSound();
      $("iframe#youtube")[0].contentWindow.postMessage('{"event":"command","func":"playVideo","args":""}','*');
    },
    close: function() {
      // Sound
      playSuccessSound();
      $("iframe#youtube")[0].contentWindow.postMessage('{"event":"command","func":"pauseVideo","args":""}','*');
    }
  }
);

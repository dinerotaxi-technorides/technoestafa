tinymce.init({
    menubar: false,
    statusbar: false,
    selector: "#configuration_webpage_company_title, #configuration_webpage_company_description",
    plugins: [
      "advlist autolink lists link image charmap print preview anchor",
      "searchreplace visualblocks code fullscreen",
      "insertdatetime media contextmenu paste"
    ],
    toolbar: "undo redo | bold italic | alignleft aligncenter alignright alignjustify | outdent indent | preview"
});

// Company
company   = new Company(
  {
    id       : companyId,
    rtaxi    : companyRtaxi,
    name     : companyName,
    domain   : companyDomain,
    latitude : 0,
    longitude: 0
  }
);

map       = $("#map_canvas").size() == 0 ? null : new Map(
  {
    id        : "map_canvas",
    latitude  : company.latitude,
    longitude : company.longitude,
    zoom      : 14,
    hideLabels: false,
    options   : {
      zoom             : 14,
      center           : new google.maps.LatLng(company.latitude, company.longitude),
      mapTypeId        : google.maps.MapTypeId.ROADMAP,
      streetViewControl: false,
      mapTypeControl   : false,
      zoomControl      : true,
      panControl       : false,
      minZoom          : 2,
      maxZoom          : 18
    }
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
    handler       : new CompanyApiHandler()
  }
);

sliderOptions = {
  animate: true,
  min: 1,
  max: 300,
  orientation: "horizontal",
  range: "min",
  slide: function(event, ui) {
    $($(this).attr("rel")).val(ui.value);
  }
};

// Slider
sliderOptions["min"] = 5;
sliderOptions["max"] = 120;
$(".slider[rel=#configuration_movement]").slider(sliderOptions);
sliderOptions["min"] = 0;
sliderOptions["max"] = 99;
$(".slider[rel=#configuration_percentage_search_ratio]").slider(sliderOptions);
sliderOptions["min"] = 0.5;
sliderOptions["max"] = 10;
$(".slider[rel=#configuration_distance]").slider(sliderOptions);
sliderOptions["max"] = 30;
$(".slider[rel=#configuration_drivers]").slider(sliderOptions);
sliderOptions["min"] = 5;
sliderOptions["max"] = 120;
$(".slider[rel=#configuration_schedule]").slider(sliderOptions);
sliderOptions["min"] = 1;
sliderOptions["max"] = 500;
$(".slider[rel=#parking_distance_driver]").slider(sliderOptions);
sliderOptions["max"] = 2000;
$(".slider[rel=#parking_distance_trip]").slider(sliderOptions);


// Slider input
$.each($(".slider"), function(index, value) {
  sliderValue = $($(value).attr("rel"));
  sliderValue.addClass("slider_value")
});

$(".slider_value").on("keyup", function() {
  slider     = $(".slider[rel=#" + $(this).attr("id") + "]");
  sliderMin  = slider.slider("option", "min");
  sliderMax  = slider.slider("option", "max");

  numericVal = parseFloat($(this).val());

  if(isNaN(numericVal))
    numericVal = 0;

  if(numericVal < sliderMin)
    numericVal = sliderMin;

  if(numericVal > sliderMax)
    numericVal = sliderMax;

  if($(this).val() != numericVal)
    $(this).val(numericVal);

  slider.slider("value", numericVal);
});

$(".slider[rel=#parking_distance_driver], .slider[rel=#parking_distance_trip]").slider({
  change: function(event, ui) {
    panel.company.configuration["search_driver_distance"]    = $(".slider[rel=#parking_distance_driver]").slider("option", "value");
    panel.company.configuration["search_passenger_distance"] = $(".slider[rel=#parking_distance_trip]").slider("option", "value");
    panel.map.refreshCirclesAndMarkerParkings();
  }
});

// Switch
$("input[type=checkbox]").switchButton({
  on_label: "",
  off_label: ""
});

$("#form_save_dialog").dialog({
  autoOpen : false,
  resizable: false,
  buttons  : [{
    text : I18n.panels.operator.accept,
    click: function() {
      // Dialog Close
      $(this).dialog("close");
    }
  }],
  open : function() {},
  close: function() {}
});

// FIXME: Copied from profile
$.ajax(
  {
    url: host + user_api + "jq_get_information_company",
    dataType: "json",
    data: {
      token: token
    },
    success: function(data)
    {
      panel.company.latitude  = data.lat;
      panel.company.longitude = data.lng;
    }
  }
);
$("#menu_configuration").addClass("active");

$("#configuration_form").submit(function() {
  tinymce.triggerSave();
  panel.api.setConfiguration({
    id       : $("#configuration_form #configuration_id").val(),
    movement : $("#configuration_form #configuration_movement").val(),
    percentageSearchRatio : $("#configuration_form #configuration_percentage_search_ratio").val(),
    distance : $("#configuration_form #configuration_distance").val(),
    schedule : $("#configuration_form #configuration_schedule").val(),
    drivers  : $("#configuration_form #configuration_drivers").val(),
    parking  : $("#configuration_form #configuration_parking").prop("checked"),

    hasMobilePayment   : $("#configuration_form #configuration_enable_mobile_payment").prop("checked"),
    hasDriverPayment   : $("#configuration_form #configuration_enable_driver_payment").prop("checked"),
    driverPayment      : $("#configuration_form #configuration_driver_payment").val(),
    driverTypePayment  : $("#configuration_form #configuration_driver_payment_type").val(),
    driverAmountPayment: $("#configuration_form #configuration_driver_payment_amount").val(),

    parkingDistanceTrip  : $("#configuration_form #parking_distance_trip").val(),
    parkingDistanceDriver: $("#configuration_form #parking_distance_driver").val(),

    zones          : $("#configuration_form #configuration_zones").prop("checked"),
    hasRequiredZone: $("#configuration_form #configuration_zones_required").prop("checked"),

    costRutePerKm   : $("#configuration_form #configuration_pricing_km_price").val(),
    costRutePerKmMin: $("#configuration_form #configuration_pricing_min_price").val(),

    pageTitle             : $("#configuration_form #configuration_webpage_title").val(),
    pageUrl               : $("#configuration_form #configuration_webpage_url").val(),
    pageCompanyTitle      : $("#configuration_form #configuration_webpage_company_title").val(),
    pageCompanyDescription: $("#configuration_form #configuration_webpage_company_description").val(),
    pageCompanyStreet     : $("#configuration_form #configuration_webpage_company_street").val(),
    pageCompanyZipCode    : $("#configuration_form #configuration_webpage_company_zipcode").val(),
    pageCompanyState      : $("#configuration_form #configuration_webpage_company_state").val(),
    pageCompanyLinkedin   : $("#configuration_form #configuration_webpage_company_linkedin").val(),
    pageCompanyFacebook   : $("#configuration_form #configuration_webpage_company_facebook").val(),
    pageCompanyTwitter    : $("#configuration_form #configuration_webpage_company_twitter").val(),

    phone : $("#configuration_form #configuration_webpage_company_phone").val(),
    phone1: $("#configuration_form #configuration_webpage_company_phone1").val()
  });

  return false;
});

$("#parking_form").submit(function() {
  // Create
  if($("#parking_form #parking_id").val() == "") {
    panel.api.addParking({
      latitude : $("#parking_form #parking_latitude").val(),
      longitude: $("#parking_form #parking_longitude").val(),
      name     : $("#parking_form #parking_name").val()
    });
  // Update
  } else {
    panel.api.updateParking({
      id       : $("#parking_form #parking_id").val(),
      latitude : $("#parking_form #parking_latitude").val(),
      longitude: $("#parking_form #parking_longitude").val(),
      name     : $("#parking_form #parking_name").val()
    });
  }

  $("#parking_id").val("");
  $("#parking_name").val("");
  $("#parking_latitude").val("");
  $("#parking_longitude").val("");
  $("#parking_form #parking_name").prop("disabled", true);
  $("#parking_form input[type=submit]").prop("disabled", true);
  $("#parking_form input[type=button]").prop("disabled", true);

  return false;
});

$(document).on("click", ".destroy_parking", function() {
  panel.api.destroyParking({
    id: $.parseJSON($(this).attr("rel")).id
  });
  $("#parking_id").val("");
  $("#parking_name").val("");
  $("#parking_latitude").val("");
  $("#parking_longitude").val("");
  $("#parking_form #parking_name").prop("disabled", true);
  $("#parking_form input[type=submit]").prop("disabled", true);
  $("#parking_form input[type=button]").prop("disabled", true);

  return false;
});

$(document).on("click", ".cancel_parking", function() {
  $("#parking_id").val("");
  $("#parking_name").val("");
  $("#parking_latitude").val("");
  $("#parking_longitude").val("");
  $("#parking_form #parking_name").prop("disabled", true);
  $("#parking_form input[type=submit]").prop("disabled", true);
  $("#parking_form input[type=button]").prop("disabled", true);
  panel.api.handler.onParkingDestroyed(true, {});

  return false;
});

$(document).on("click", ".new_parking", function() {
  center = panel.map.map.getCenter();
  panel.map.addDraggableMarkerParking(new Parking({id: "new", name: "", latitude: center.lat(), longitude: center.lng()}), function(data) {
    $("#parking_latitude").val(data.lat());
    $("#parking_longitude").val(data.lng());
  }, function(data, marker) {
    panel.map.refreshCirclesAndMarkerParkings();
  });

  $("#parking_id").val("");
  $("#parking_name").val("");
  $("#parking_latitude").val(center.lat());
  $("#parking_longitude").val(center.lng());
  $("#parking_form #parking_name").prop("disabled", false);
  $("#parking_form input[type=submit]").prop("disabled", false);
  $("#parking_form input[type=button]").prop("disabled", false);
  panel.map.refreshCirclesAndMarkerParkings();

  return false;
});

$(document).on("click", ".edit_parking", function() {
  parkingJson = $.parseJSON($(this).attr("rel"));
  if(panel.map.markers["parking_new"] != undefined) {
    panel.map.markers["parking_new"].marker.setMap(null);
    panel.map.markers["parking_new"] = undefined;
  }

  $("#parking_form #parking_id").val(parkingJson.id);
  $("#parking_form #parking_name").val(parkingJson.name);
  $("#parking_form #parking_latitude").val(parkingJson.lat);
  $("#parking_form #parking_longitude").val(parkingJson.lng);

  // FIXME: Find a way to differenciate automatic clicks from manual clicks
  if($(this).data("automatic_click") != true)
    panel.map.panTo(parkingJson.lat, parkingJson.lng);

  $("#parking_form #parking_name").prop("disabled", false);
  $("#parking_form input[type=submit]").prop("disabled", false);
  $("#parking_form input[type=button]").prop("disabled", false);

  panel.map.refreshCirclesAndMarkerParkings();

  return false;
});

$(document).on("click", ".edit_zone", function() {
  zoneJson = $.parseJSON($(this).attr("rel"));

  if($("#zone_form #zone_id").val() != zoneJson.id) {
    $("#zone_form #zone_id").val(zoneJson.id);
    $("#zone_form #zone_name").val(zoneJson.name);
    $("#zone_form #zone_latitude1").val(zoneJson.latitude1);
    $("#zone_form #zone_longitude1").val(zoneJson.longitude1);
    $("#zone_form #zone_latitude2").val(zoneJson.latitude2);
    $("#zone_form #zone_longitude2").val(zoneJson.longitude2);

    // FIXME: Find a way to differenciate automatic clicks from manual clicks
    if($(this).data("automatic_click") != true)
      panel.map.panTo(((zoneJson.latitude1 + zoneJson.latitude2)/2), ((zoneJson.longitude1 + zoneJson.longitude2)/2));

    $("#zone_form #zone_name").prop("disabled", false);
    $("#zone_form input[type=submit]").prop("disabled", false);
    $("#zone_form input[type=button]").prop("disabled", false);

    panel.map.refreshRectanglesZones(zoneJson.id);
  }

  return false;
});

$(document).on("click", ".cancel_zone", function() {
  $("#zone_id").val("");
  $("#zone_name").val("");
  $("#zone_latitude1").val("");
  $("#zone_longitude1").val("");
  $("#zone_latitude2").val("");
  $("#zone_longitude2").val("");
  $("#zone_form #zone_name").prop("disabled", true);
  $("#zone_form input[type=submit]").prop("disabled", true);
  $("#zone_form input[type=button]").prop("disabled", true);
  panel.api.handler.onZoneDestroyed(true, {});

  return false;
});

$(document).on("click", ".new_zone", function() {
  panel.map.refreshRectanglesZones();

  newZoneBoundsDistance = 0.01;
  center = panel.map.map.getCenter();
  panel.map.addRectangleZone(new Zone({id: "new", name: "", latitude1: center.lat() - newZoneBoundsDistance, longitude1: center.lng() - newZoneBoundsDistance, latitude2: center.lat() + newZoneBoundsDistance, longitude2: center.lng() + newZoneBoundsDistance}), {
    click         : function(data) {},
    dragstart     : function(data) {},
    dragend       : function(data) {},
    bounds_changed: function(data) {
      latLng1 = data.getBounds().getSouthWest();
      latLng2 = data.getBounds().getNorthEast();
      $("#zone_latitude1").val(latLng1.lat());
      $("#zone_longitude1").val(latLng1.lng());
      $("#zone_latitude2").val(latLng2.lat());
      $("#zone_longitude2").val(latLng2.lng());
      rectangleValidator = new Rectangle({id: data.rectangleId, latitude1: latLng1.lat(), longitude1: latLng1.lng(), latitude2: latLng2.lat(), longitude2: latLng2.lng()});
      $("#zone_form input[type=submit]").prop("disabled", !rectangleValidator.hasValidBounds());
    }
  });

  $("#zone_id").val("");
  $("#zone_name").val("");
  $("#zone_latitude1").val(center.lat() - newZoneBoundsDistance);
  $("#zone_longitude1").val(center.lng() - newZoneBoundsDistance);
  $("#zone_latitude2").val(center.lat() + newZoneBoundsDistance);
  $("#zone_longitude2").val(center.lng() + newZoneBoundsDistance);
  $("#zone_form #zone_name").prop("disabled", false);
  rectangleValidator = new Rectangle({id: "zone_new", latitude1: $("#zone_latitude1").val(), longitude1: $("#zone_longitude1").val(), latitude2: $("#zone_latitude2").val(), longitude2: $("#zone_longitude2").val()});
  $("#zone_form input[type=submit]").prop("disabled", !rectangleValidator.hasValidBounds());
  $("#zone_form input[type=button]").prop("disabled", false);

  return false;
});

$(document).on("click", ".destroy_zone", function() {
  panel.api.destroyZone({
    id: $.parseJSON($(this).attr("rel")).id
  });
  $("#zone_id").val("");
  $("#zone_name").val("");
  $("#zone_latitude1").val("");
  $("#zone_longitude1").val("");
  $("#zone_latitude2").val("");
  $("#zone_longitude2").val("");
  $("#zone_form #zone_name").prop("disabled", true);
  $("#zone_form input[type=submit]").prop("disabled", true);
  $("#zone_form input[type=button]").prop("disabled", true);

  return false;
});

$("#zone_form").submit(function() {
  // Create
  if($("#zone_form #zone_id").val() == "") {
    panel.api.addZone({
      latitude1 : $("#zone_form #zone_latitude1").val(),
      longitude1: $("#zone_form #zone_longitude1").val(),
      latitude2 : $("#zone_form #zone_latitude2").val(),
      longitude2: $("#zone_form #zone_longitude2").val(),
      name      : $("#zone_form #zone_name").val()
    });
  // Update
  } else {
    panel.api.updateZone({
      id        : $("#zone_form #zone_id").val(),
      latitude1 : $("#zone_form #zone_latitude1").val(),
      longitude1: $("#zone_form #zone_longitude1").val(),
      latitude2 : $("#zone_form #zone_latitude2").val(),
      longitude2: $("#zone_form #zone_longitude2").val(),
      name      : $("#zone_form #zone_name").val()
    });
  }

  $("#zone_id").val("");
  $("#zone_name").val("");
  $("#zone_latitude1").val("");
  $("#zone_longitude1").val("");
  $("#zone_latitude2").val("");
  $("#zone_longitude2").val("");
  $("#zone_form #zone_name").prop("disabled", true);
  $("#zone_form input[type=submit]").prop("disabled", true);
  $("#zone_form input[type=button]").prop("disabled", true);

  return false;
});

$(function(){panel.api.getConfiguration()});

// Update jqGrid
// this is only used in company panel, #FIXME!
updateJqGrid();

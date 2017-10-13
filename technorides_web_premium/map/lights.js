google.maps.event.addDomListener(window, 'load', init);
var map;
var cluster;
var url = 'http://technorides.co:2001/company_info';
var setedTotal = false;
var country = "USA";

var contryName = "United States of America";

var countries = [];



function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}



function changeCountry(code){
  setedTotal = false
  country = code
  if(getParameterByName("country")){
    country = getParameterByName("country")
  }
  getLights(0,country)
  countryName = ""
  $.each(countries, function(index, value){
    if(code==value.code){
      countryName = value.name
    }
  })

  $("#countries").val(code)
  $("#companies-place").text(countryName)

  
}
$.ajax({
  dataType: "json",
  url: "countries.json",
  success: function(response){
    countries = response.countries
    $.each(countries, function(index, value){
      if(country==value.code){
      $("#countries").append("<option value='"+value.code+"' selected>"+value.name+"</option>")
      }else{
      $("#countries").append("<option value='"+value.code+"'>"+value.name+"</option>")
      }
    })
  }
});
// Add Light
function addLight(latitude, longitude, title) {
  var marker = new google.maps.Marker({
    position : new google.maps.LatLng(latitude, longitude),
    map      : map,
    title    : title,
    icon     : 'img/marker.png'
  });

  cluster.addMarker(marker);
};

// Load lights
function getLights(page, country) {
  $.getJSON(url + "/" + page + "/" + country, function(data) {
      //if hasnt show total companies start the count
      if(!setedTotal){
        options = {
          separator : '.'
        }
        animation = new CountUp("companies-number",0 , data.count_record,0,20, options)
        animation.start()
        setedTotal = true
      }
      $.each(data.data, function(index, value) {
        addLight(value.location.lat, value.location.lng, value.name);
      });

      if(data.data.length > 0)
        setTimeout(function() {
          getLights(++page, country);
        }, 1000);
  });
}
//google maps init
function init() {
  // Map
  var mapOptions = {
    disableDefaultUI: true,
    zoom    : 3,
    minZoom : 3,
    center  : new google.maps.LatLng(0, 0),
    styles  : [{"featureType":"all","elementType":"labels.text.fill","stylers":[{"saturation":36},{"color":"#000000"},{"lightness":40}]},{"featureType":"all","elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":"#000000"},{"lightness":16}]},{"featureType":"all","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"administrative","elementType":"geometry.fill","stylers":[{"color":"#000000"},{"lightness":20}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#000000"},{"lightness":17},{"weight":1.2}]},{"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":20}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":21}]},{"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#000000"},{"lightness":17}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#000000"},{"lightness":29},{"weight":0.2}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":18}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":16}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":19}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"},{"lightness":17}]}]
  };
  var mapElement = document.getElementById('map');
  map            = new google.maps.Map(mapElement, mapOptions);

  // Bounds of the desired area
  var allowedBounds = new google.maps.LatLngBounds(
       new google.maps.LatLng(-65, -80),
       new google.maps.LatLng(65, 80)
  );
  var lastValidCenter = map.getCenter();

  google.maps.event.addListener(map, 'center_changed', function() {
      if (allowedBounds.contains(map.getCenter())) {
          // Still within valid bounds, so save the last valid position
          lastValidCenter = map.getCenter();
          return; 
      }

      // Not valid anymore => return to last valid position
      map.panTo(lastValidCenter);
  });

  // Cluster
  var clusterOptions = {
    styles: [
      {
        url       : 'img/m1.png',
        height    : 53,
        width     : 52,
        textColor : 'black',
        textSize  : 12
      },
      {
        url       : 'img/m2.png',
        height    : 56,
        width     : 55,
        textColor : 'black',
        textSize  : 12
      },
      {
        url       : 'img/m3.png',
        height    : 66,
        width     : 65,
        textColor : 'black',
        textSize  : 12
      },
      {
        url       : 'img/m4.png',
        height    : 78,
        width     : 77,
        textColor : 'black',
        textSize  : 12
      },
      {
        url       : 'img/m5.png',
        height    : 90,
        width     : 89,
        textColor : 'black',
        textSize  : 12
      }
    ]
  };
  cluster = new MarkerClusterer(map, [], clusterOptions);
  $("document").ready(function(){
    $("#countries").change(function(){
      window.location = "?country="+this.value
    });
  });
if(!getParameterByName("country")){
  changeCountry("USA")
}else{
  changeCountry(getParameterByName("country"))
}
  // Get Lights
  
};

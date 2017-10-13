// Button
$(".button").button();

// Help
$("#help_link").click(
  function() {
    $("#zenbox_tab").click();
  }
);

// Settings
$("#settings_link").click(
  function() {
    $("#settings_dialog").dialog("open");
  }
);

$("#settings_theme").change(
  function() {
    applyTheme($(this).val());
  }
);

// Logout
$("#logout_link").click(
  function() {
    // Dialog
    $("#logout_dialog").dialog("open");
  }
);

// Pan to my location
$("#pan_to_my_location_link").click(
  function() {
    panel.map.showAllMarkers();
  }
);

// Dialogs
// Ring User
$("#ring_user_operation_dialog").dialog(
  {
    autoOpen: false,
    buttons : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Operation ID
          operationId = parseInt($("#ring_user_operation_operation_id").text());
          panel.company.ringUserOperation(operationId);

          // Dialog Close
          $(this).dialog("close");
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          $("#ring_user_operation_operation_id").text("");
          $(this).dialog("close");
        }
      }
    ],
    open : function() {
      // Sound
      playAnswerSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// Error
$("#form_error_dialog").dialog(
  {
    autoOpen: false,
    buttons : [
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

// Logout
$("#logout_dialog").dialog(
  {
    autoOpen: false,
    buttons : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Logout
          window.location.href = "/" + language + "/logout";
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
      // Sound
      playSuccessSound();
    }
  }
);

// Settings
$("#settings_dialog").dialog(
  {
    autoOpen: false,
    buttons : [
      {
        text : I18n.panels.operator.accept,
        click: function() {
          // Cookie
          createCookie("technorides_mute", $("#settings_mute").prop("checked"), 99999);

          themeName = $("#settings_theme").val();
          createCookie("technorides_theme", themeName, 99999);

          languageName = $("#settings_language").val();
          createCookie("technorides_language", languageName, 99999);
          applyLanguage(languageName);

          // Dialog Close
          $(this).dialog("close");
        }
      },
      {
        text : I18n.panels.operator.cancel,
        click: function() {
          // Settings
          readSettings();

          // Dialog
          $(this).dialog("close");
        }
      },
    ],
    open : function() {
      // Sound
      playAnswerSound();
    },
    close: function() {
      // Sound
      playSuccessSound();
    }
  }
);

// New Trip Sound
function playNewTripSound() {
  playSound("#new_trip_sound");
}

// Success Sound
function playSuccessSound()
{
  playSound("#success_sound");
}

// Error Sound
function playErrorSound() {
  playSound("#error_sound");
}

// Success Answer
function playAnswerSound() {
  playSound("#answer_sound");
}

// Play Sound
function playSound(soundId) {
  // Mute?
  if(!$("#settings_mute").prop("checked"))
    $(soundId).get(0).play()
}

// Create Cookie
function createCookie(name, value, days) {
  if(days) {
    var date = new Date();
    date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
    var expires = "; expires=" + date.toGMTString();
  }
  else var expires = "";
  document.cookie = escape(name) + "=" + escape(value) + expires + "; path=/";
}

// Read Cookie
function readCookie(name) {
  var nameEQ = escape(name) + "=";
  var ca = document.cookie.split(';');
  for(var i = 0; i < ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') c = c.substring(1, c.length);
    if (c.indexOf(nameEQ) == 0) return unescape(c.substring(nameEQ.length, c.length));
  }
  return null;
}

// Erase Cookie
function eraseCookie(name) {
  createCookie(name, "", -1);
}

// Generate Timezones list
$.each(WallTime.zones, function(key, value) {
  if(key.indexOf("/") > -1 && key.indexOf("-") == -1 && key.indexOf("+") == -1 && key.indexOf("Etc") == -1)
    $("#settings_timezone").append("<option value='" + key + "'>" + key.replace("/", ", ").replace("/", ", ").replace("_", " ").replace("_", " ") + "</option>");
});
$("#settings_timezone").sort_select_box();

// Settings
function readSettings() {
  $("#settings_mute").prop("checked", readCookie("technorides_mute") == "true");

  themeName = readCookie("technorides_theme");
  if(themeName == null || themeName == undefined)
    themeName = "dark-hive";
  $("#settings_theme").val(themeName);
  applyTheme(themeName);

  languageName = readCookie("technorides_language");
  if(languageName == null || languageName == undefined)
    languageName = language;
  $("#settings_language").val(languageName);

  if(language != languageName)
    applyLanguage(languageName);

  timezone = readCookie("technorides_timezone");
  if(timezone == null || timezone == undefined) {
    if(panel != undefined && panel.company != undefined) {
      timezone = panel.company.timezone;
    } else {
      timezone = companyTimezone;
    }
  } else {
    if(panel != undefined && panel.company != undefined) {
      panel.company.timezone = timezone;
    }
  }
  $("#settings_timezone").val(timezone);
}

// First call
readSettings();

// Apply theme
function applyTheme(themeName) {
  $("head").append("<link rel='stylesheet' type='text/css' href='http://code.jquery.com/ui/1.10.3/themes/" + themeName + "/jquery-ui.css'>");
}

// Apply language
function applyLanguage(languageName) {
  urlPath = window.location.pathname;
  location.href = "/" + languageName + urlPath.substr(3, urlPath.length - 3);
}

// Hover table style
$(document).on("mouseenter", "tbody.ui-widget-content tr",
  function() {
    $(this).addClass("ui-state-highlight");
  }
);

$(document).on("mouseleave", "tbody.ui-widget-content tr",
  function() {
    $(this).removeClass("ui-state-highlight");
  }
);

// Counters
function getCounters() {
  $.ajax(
    {
      dataType: "json",
      url     : httpServerCounters,
      data    : {
        token: panel.api.token
      },
      success : function(data) {
        $("#users_counter_number").html(data.customers);
        $("#operations_counter_number").html(data.operations);
      }
    }
  )
}

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

company   = new Company(
  {
    id       : companyId,
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
    zoom      : 12,
    hideLabels: false
  }
);
var panel = new Panel(
  {
    company: company,
    map    : map
  }
);
panel.api           = new Api(
  {
    baseUrl       : apiBaseUrl,
    reloginUrl    : apiReloginUrl,
    token         : apiToken,
    maxFavorites  : maxFavorites,
    defaultCountry: defaultCountry,
    defaultCcode  : defaultCcode,
    handler       : new MonitorApiHandler()
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

getCounters();
setInterval(function(){getCounters()}, countersTimer);

// Marker
panel.addMarker();
